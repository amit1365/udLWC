import { LightningElement } from 'lwc';
import { RefreshEvent } from 'lightning/refresh'; 

export default class QuizApp extends LightningElement {

    
    //it is an array of objects, each object represents a question
    questions = [
        {   id: 1,
            question: 'What is the capital of France?',
            options: {a:'Paris',
                      b:'London', 
                      c:'Berlin'},
            answer: 'a'},

        {   id: 2,
            question: 'What is the largest planet in our solar system?',
            options: {a:'Earth',
                      b:'Jupiter',
                      c:'Mars'},
            answer: 'b'},

        {   id: 3,
            question: 'What is the chemical symbol for water?',
            options: {a:'H2O',
                      b:'CO2',
                      c:'O2'},
            answer: 'a'},

        {   id: 4,
            question: 'Who wrote "To Kill a Mockingbird"?',
            options: {a:'Harper Lee',
                      b:'Mark Twain',
                      c:'Ernest Hemingway'},
            answer: 'a'},

        {   id: 5,
            question: 'What is the name of the first novel written by George Orwell?',
            options: {a:'1984',
                      b: 'Animal Farm',
                      c:'Down and Out in Paris and London'},
            answer: 'c'},
        {   id: 6,
            question: 'What is the largest mammal in the world?',
            options: {a:'Elephant',
                      b:'Blue Whale',
                      c:'Giraffe'},
            answer: 'b'},

        {   id: 7,
            question: 'What is the capital of Japan?',
            options: {a:'Tokyo',
                      b:'Seoul',
                      c:'Beijing'},
            answer: 'a'},

        {   id: 8,
            question: 'What is the smallest country in the world?',
            options: {a:'Vatican City',
                      b:'Monaco',
                      c:'San Marino'},
            answer: 'a'},

        {   id: 9,
            question: 'What is the largest ocean in the world?',
            options: {a:'Atlantic Ocean',
                      b:'Indian Ocean',
                      c:'Pacific Ocean'},
            answer: 'c'},

        {   id: 10,
            question: 'Who is called the father of modern physics?',
            options: {a:'Isaac Newton',
                      b:'Albert Einstein',
                      c:'Galileo Galilei'},
            answer: 'b'},
    ]

    
    selected = {};
    totalScore = 0;
    
    changeHandler(event) {
        console.log('event.target.value: ' + event.target.value);
        console.log('event.target.name: ' + event.target.name);
        const{name, value} = event.target;
        this.selected = {...this.selected, [name]: value};
    }

    handleSubmit(event){
        //alert('here')
        /*if(Object.keys(this.selected).length !== this.questions.length) {
            alert('Please answer all questions before submitting.');
            return;
        }*/
        this.totalScore = 0;
        this.questions.forEach(question => {
            if(this.selected[question.id] === question.answer) {
                this.totalScore++;
            }
        }
        );
        alert(`Your total score is ${this.totalScore} out of ${this.questions.length}`);
        //this.selected = {}; // Reset selected answers after submission
        // To refresh the component, reset the selected answers and score
        
        this.resetQuiz()
    }

        resetQuiz(){

        this.selected = {};
        this.totalScore = 0;
        // Reset all radio buttons to unselected
        const inputs = this.template.querySelectorAll('input[type="radio"]');
        inputs.forEach(input => input.checked = false);
        }
}