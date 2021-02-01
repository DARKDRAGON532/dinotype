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
                    <button id="redo" tabindex="1">Redo</button>
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
            testTime: 0,
            type: null,
            timerStart: true,
            words: null,
            htmlWords: null,
            currentWord: "",
            wordIndex: 0,
            charIndex: 0,
            correctChars: 0,
            correctWords: 0
        }
    },
    mounted() {
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
                document.getElementById("words").innerHTML = words;
                document.getElementById("score").innerHTML = `0/${amt}`;
            } 
            else if (type === "time") {
                console.log(amt, type) 
                let words = ""
                this.testTime = parseInt(amt);
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
                        document.getElementById("score").innerHTML = `${(this.correctChars/5)/(this.testTime/60)} WPM`
                        clearInterval(countdown)
                    }
            }, 1000)
            } else if (!this.timerStart) {
                // console.log(event.data, this.words[this.wordIndex][this.charIndex])
                this.checkWord(event.data)
            }
        },
        checkWord(char) {
            this.words = document.getElementById("words").innerText.split(" ");
            if (char == this.words[this.wordIndex][this.charIndex]) {
                this.charIndex++
                this.currentWord += char;
                this.correctChars++;
                this.htmlWords[this.wordIndex] = `<em class="correct">${this.words[this.wordIndex]}</em>`
                document.getElementById("words").innerHTML = this.htmlWords.join(" ");
            } else if (char == " ") {
                if (this.currentWord != this.words[this.wordIndex]) {
                   this.htmlWords[this.wordIndex] = `<em class="wrong">${this.words[this.wordIndex]}</em>`
                   document.getElementById("words").innerHTML = this.htmlWords.join(" ");
                } else {
                    this.correctWords++;
                }
                this.completedWords++;
                this.wordIndex++
                this.charIndex = 0;
                this.currentWord = ""
                document.getElementById("typing-input").value = "";
            } else if (char == null) {
                this.charIndex -= 2;
                if (this.charIndex < 0) {
                    this.charIndex = 0;
                }
                this.currentWord = this.currentWord.substring(0, this.currentWord.length - 1)
                console.log(this.currentWord)
                console.log(this.charIndex)
                console.log(this.currentWord.charAt(this.charIndex), this.words[this.wordIndex][this.charIndex])
                if (this.currentWord[this.charIndex] == this.words[this.wordIndex][this.charIndex]) {
                    this.charIndex++;
                    if (!this.htmlWords[this.wordIndex].includes('class="wrong"')) {
                        this.htmlWords[this.wordIndex] = `<em class="correct">${this.words[this.wordIndex]}</em>`
                    }
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
            
        }
    }
}
</script>

<style scoped>
    #typing-area {
        margin-top: 5vh;
    }

    #words {
        display: inline-block;
        padding: 10px;
        font-size: 18px;
        max-width: 50vw;
    }

    #score {
        margin-bottom: 5vh;
        font-size: 48px;
    }

    #config span {
        cursor: pointer;
    }
</style>