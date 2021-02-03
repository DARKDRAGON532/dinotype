<template>
    <div id="type">
        <div id="config">
            <div id="time">
                <span @click="set(15, 'time')">15s</span>
                /
                <span @click="set(30, 'time')">30s</span>
                /
                <span @click="set(60, 'time')">60s</span>
                /
                <span @click="set(120, 'time')">120s</span>
            </div>
            <div id="word">
                <span @click="set(10, 'word')">10 Words</span>
                /
                <span @click="set(20, 'word')">20 Words</span>
                /
                <span @click="set(50, 'word')">50 Words</span>
                /
                <span @click="set(100, 'word')">100 Words</span>
            </div>
            <div id="typing-area">
                <div id="score"></div>
                <div id="words"></div>
                <div id="typing-area">
                    <input type="text" id="typing-input" @input="onType" placeholder="Start typing..." spellcheck="false" autocomplete="off" autocorrect="off" autocapitalize="off" tabindex="2" autofocus>
                    <button id="redo" tabindex="1" @click="redo()">Redo</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
const wordsList = require('../data/words.json')

export default {
    name: "Typing",
    data: function() {
        return {
            time: 0,
            testValue: 50,
            type: "word",
            timerStart: true,
            words: null,
            htmlWords: null,
            currentWord: "",
            wordIndex: 0,
            charIndex: 0,
            correctChars: 0,
            correctWords: 0,
            completedWords: 0
        }
    },
    mounted() {
        document.onkeydown = e => {
            if (e.key == "Escape") {this.redo()}
        }
        this.set(50, 'word')
    },
    methods: {
        set(amt, type) {
            if (type === "word") {
                console.log(amt, type)
                let words = ""
                this.type = type;
                for (let i = 0; i < amt; i++) {
                    const index = Math.floor(Math.random() * wordsList["english"].length);
                    words += wordsList["english"][index] + " "
                }
                this.htmlWords = words.split(" ")
                this.time = 0
                this.testValue = parseInt(amt)
                document.getElementById("words").innerHTML = words;
                document.getElementById("score").innerHTML = `0/${amt}`;
            } 
            else if (type === "time") {
                console.log(amt, type) 
                let words = ""
                this.testValue = parseInt(amt);
                this.time = parseInt(amt);
                this.type = type;

                for (let i = 0; i < amt * 4; i++) {
                    const index = Math.floor(Math.random() * wordsList["english"].length);
                    words += wordsList["english"][index] + " "
                }
                this.htmlWords = words.split(" ")
                document.getElementById("words").innerHTML = words;
                document.getElementById("score").innerHTML = `${amt}s`;
            }
        },
        onType(event) {
            this.words = document.getElementById("words").innerText.split(" ");

            if (this.type === "time" && this.timerStart && this.time > 0) {
                this.timerStart = false;
                this.checkWord(event.data)
                const countdown = setInterval(() => {
                    this.time -= 1;
                    document.getElementById("score").innerHTML = `${this.time}s`;
                    if (this.time <= 0) {
                        document.getElementById("score").innerHTML = "0s";
                        this.timerStart = true;
                        document.getElementById("score").innerHTML = `${Math.round((this.correctChars/5)/(this.testValue/60))} WPM`
                        clearInterval(countdown)
                    }
            }, 1000)
            } else if (this.type === "word" && this.timerStart) {
                this.timerStart = false;
                this.checkWord(event.data)
                global.countdown = setInterval(() => {
                    this.time += 1;
                    if (this.completedWords == this.testValue) {
                        this.timerStart = true;
                        document.getElementById("score").innerHTML = `${Math.round((this.correctChars/5)/(this.testValue/60))} WPM`
                        clearInterval(global.countdown)
                    }
            }, 1000)
            } else if (!this.timerStart) {
                this.checkWord(event.data)
            }
        },
        checkWord(char) {
            if (document.getElementById("typing-input").value == "") {
                this.currentWord = ""
                this.charIndex = 0
                this.htmlWords[this.wordIndex] = this.words[this.wordIndex]
                document.getElementById("words").innerHTML = this.htmlWords.join(" ");
                return
            }
            this.words = document.getElementById("words").innerText.split(" ");
            if (char == this.words[this.wordIndex][this.charIndex]) {
                this.charIndex++
                this.currentWord += char;
                this.correctChars++;
            } else if (char == " ") {
                if (this.currentWord != this.words[this.wordIndex]) {
                   this.htmlWords[this.wordIndex] = `<em class="wrong">${this.words[this.wordIndex]}</em>`
                   document.getElementById("words").innerHTML = this.htmlWords.join(" ");
                } else {
                    this.htmlWords[this.wordIndex] = `<em class="correct">${this.words[this.wordIndex]}</em>`
                    document.getElementById("words").innerHTML = this.htmlWords.join(" ");
                    this.correctWords++;
                }
                this.completedWords++;
                this.wordIndex++
                this.charIndex = 0;
                this.currentWord = ""
                document.getElementById("typing-input").value = "";
                if (this.type == "word") {
                    if (this.completedWords == 10) {
                        this.timerStart = true;
                        document.getElementById("score").innerHTML = `${Math.round((this.correctChars/5)/(this.testValue/60))} WPM`
                        clearInterval(global.countdown)    
                    }
                    document.getElementById("score").innerHTML = `${this.completedWords}/${this.testValue}`;
                }
            } else if (char == null) {
                this.charIndex -= 2;
                this.charIndex = this.charIndex < 0 ? 0 : this.charIndex
                this.currentWord = this.currentWord.substring(0, this.currentWord.length - 1)
                console.log(this.currentWord)
                console.log(this.charIndex)
                console.log(this.currentWord[this.charIndex], this.words[this.wordIndex][this.charIndex])
                if (this.currentWord[this.charIndex] == this.words[this.wordIndex][this.charIndex]) {
                    this.charIndex++;
                    this.htmlWords[this.wordIndex] = this.words[this.wordIndex]
                    document.getElementById("words").innerHTML = this.htmlWords.join(" ");
                } else {
                    this.charIndex++;
                    this.htmlWords[this.wordIndex] = `<em class="wrong">${this.words[this.wordIndex]}</em>`
                    document.getElementById("words").innerHTML = this.htmlWords.join(" ");
                }
            } else {
                this.charIndex++;
                this.currentWord += char;
                this.htmlWords[this.wordIndex] = `<em class="wrong">${this.words[this.wordIndex]}</em>`
                document.getElementById("words").innerHTML = this.htmlWords.join(" ");
            }
            
        },
        redo() {
            this.timerStart = true
            this.words = null
            this.htmlWords = null
            this.currentWord = ""
            this.wordIndex = 0
            this.charIndex = 0
            this.correctChars = 0
            this.correctWords = 0
            this.completedWords = 0
            document.getElementById("typing-input").value = ""
            this.set(this.testValue, this.type)
        }
    }
}
</script>

<style scoped>
    #typing-area {
        margin-top: 5vh;
    }

    #redo {
        border: 1px solid #000;
        background-color: #000;
        border-radius: 5px;
        padding: 3px;
        transition: background-color 0.5s;
    }

    #redo:hover {
        cursor: pointer;
        background-color: #111111;
    }

    #typing-input {
        border: none;
        outline: none;
    }

    #words {
        display: inline-block;
        padding: 10px;
        font-size: 24px;
        max-width: 50vw;
        max-height: 50vh;
    }

    #score {
        margin-bottom: 5vh;
        font-size: 64px;
    }

    #config span {
        cursor: pointer;
    }
</style>