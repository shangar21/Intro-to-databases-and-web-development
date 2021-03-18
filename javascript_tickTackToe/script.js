var current_play = ['','','','','','','','','']
var check_complete = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6]
]

function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
}

function computer_turn(current_play){
    available_spots = []

    for (var i = 0; i < 9; i++){
        if (current_play[i] == ''){
            available_spots.push(i);
        }
    }

    computer_spot = available_spots[Math.floor(Math.random() * Math.floor(available_spots.length))];

    current_play[computer_spot] = 'O';

}

function fill_cells(current_play){
    x = document.querySelectorAll('.cell');
    for (var i = 0; i < x.length; i++){
        c_index = x[i].getAttribute('cell-index')
        x[i].innerHTML = current_play[c_index]
    }
}

function empty_cells(current_play){
    current_play = ['','','','','','','','',''];
    fill_cells(current_play);
}

function check_win(current_play){
    winner = ['XXX', 'OOO'];
    for (var i = 0; i < check_complete.length; i++){
        wtc = [current_play[check_complete[i][0]], current_play[check_complete[i][1]], current_play[check_complete[i][2]]];
        
        if (wtc.join('') == 'XXX'){
            return 'X';
        }
        else if (wtc.join('') == 'OOO'){
            return 'O'
        }
    }
    
    return '';

}

function cell_clicked(event){
        
    if (current_play[event.target.getAttribute('cell-index')] == ''){
        current_play[event.target.getAttribute('cell-index')] = current_play[event.target.getAttribute('cell-index')] != "O"? "X":'';check_win(current_play);

        if (check_win(current_play) != ''){
            alert("Game over: " + check_win(current_play) + " won!");
            empty_cells(current_play);
        }
        computer_turn(current_play);
    }
    
    fill_cells(current_play);

    

    // if (check_win(current_play) != ''){
    //     alert("Game over: " + check_win(current_play) + " won!");
    //     empty_cells(current_play);
    // }

}


document.querySelectorAll('.cell').forEach(cell => cell.addEventListener('click', cell_clicked))