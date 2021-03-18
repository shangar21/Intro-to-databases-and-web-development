// returns a random number between 0 and "max" (exclusive)
function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
}

function getWinner(human, pc){
    let plays = {'ROCK':1, 'PAPER':2, 'SCISSORS':3};
    let results = [2,1,3,2];

    const isEqual = (element) => element == plays[human];

    if (results[results.findIndex(isEqual) + 1] == plays[pc]){
        return 'PLAYER'
    }
    else if (results[results.findIndex(isEqual)] == plays[pc]){
        return 'DRAW'
    }
    return 'COMPUTER'

}

// determine if the game is a win, loss, or tie
// this function should not return anything, edit the HTML accordingly
function play(action) {
    // keep track of what the computer and player intend to do
    let plays = {0:'ROCK', 1:'PAPER', 2:'SCISSORS'};
    let computerAction = plays[getRandomInt(3)];
    let playerAction = action;

    // keep track of the player, computer, and end message
    let playerMessage = 'The PLAYER chooses: ' + action + '!';
    let computerMessage = 'The COMPUTER chooses: ' + computerAction + '.';
    let endMessage = getWinner(action, computerAction) != 'DRAW'? 'The ' + getWinner(action, computerAction) + ' wins!': 'PLAYER and COMPUTER draw!';

    // randomly assign an action to the computer
    // TODO: complete this code


    // assign the player's and computer's message accordingly
    // TODO: complete this code


    // handle who wins or loses
    // update the end message accordingly
    // TODO: complete this code
    let gameContent = document.getElementById('game-content');
    let listItem = document.createElement('li');
    listItem.appendChild(document.createTextNode(playerMessage + '\t' + computerMessage + '\t' + endMessage));
    gameContent.appendChild(listItem);

    // update the game log
    // TODO: complete this code
    
    // get the actual element
    // create the list items
    // add the list items to the list in the HTML
}