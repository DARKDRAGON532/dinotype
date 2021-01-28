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
                /
            </div>
            <div id="word">
                <span @click="set(10, 'word')">10 Words</span>
                /
                <span @click="set(20, 'word')">20 Words</span>
                /
                <span @click="set(50, 'word')">50 Words</span>
                /
                <span @click="set(100, 'word')">100 Words</span>
                /
            </div>
        </div>
        <div id="words"></div>
        <div id="typing-area">
            <input type="text" id="typing-input" placeholder="Start typing..." autocomplete="off" spellcheck="false" tabindex="2" autofocus>
            <button id="redo" tabindex="1">Redo</button>
        </div>
    </div>
</template>

<script>
const wordsList = require('../data/words.json')

export default {
    name: "Typing",
    data: function() {
        return {
            
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
                for (let i = 0; i < amt; i++) {
                    const index = Math.floor(Math.random() * wordsList["english"].length);
                    words += wordsList["english"][index] + " "
                }
                document.getElementById("words").innerHTML = words
            } 
            else if (type === "time") {
                console.log(amt, type)
            }
        }
    }
}
</script>

<style scoped>
    #config span {
        cursor: pointer;
    }
</style>