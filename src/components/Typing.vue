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
                    <input type="text" id="typing-input" @input="onType()" placeholder="Start typing..." autocomplete="off" spellcheck="false" tabindex="2" autofocus>
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
            time: null,
            type: null
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
                document.getElementById("words").innerHTML = words;
                document.getElementById("score").innerHTML = `0/${amt}`;
            } 
            else if (type === "time") {
                console.log(amt, type) 
                let words = ""
                this.time = parseInt(amt);
                this.type = type;

                for (let i = 0; i < amt * 4; i++) {
                    const index = Math.floor(Math.random() * wordsList["english"].length);
                    words += wordsList["english"][index] + " "
                }
                document.getElementById("words").innerHTML = words;
                document.getElementById("score").innerHTML = `${amt}s`;
            }
        },
        onType() {
            console.log("started")
            if (this.type === "time") {
                console.time('looper');
                const countdown = setInterval(() => {
                    this.time -= 1;
                    document.getElementById("score").innerHTML = `${this.time}s`;
                    if (this.time === 0) {
                        clearInterval(countdown)
                    }
                    console.timeLog('looper');
            }, 1000)
            }
        },
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
        max-width: 75vw;
    }

    #score {
        margin-bottom: 5vh;
        font-size: 48px;
    }

    #config span {
        cursor: pointer;
    }
</style>