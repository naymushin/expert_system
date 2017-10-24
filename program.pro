database

right(string, char) % right answer of user ‘char’ to the question ‘string’
wrong(string, char) % wrong answer of user ‘char’ to the question ‘string’

predicates

nondeterm data(string, char)
/* Predicate forms string of question and right answer to this question */
    
process(string, char) % (Quest, Ans)
/* Predicate accepts two parameters on input:
 *   Quest    - string of question;
 *   Ans      - right answer on question.
 * Predicate displays string of question on the screen,
 * enters user answer from keyboard, also displays it
 * on the screen and adds new clause in database
 * using predicate ‘updatebase’ */
  
updatebase(string, char, char) % (Quest, Ans, Key)
/* Predicate accepts three input parameters: 
 *  Quest    - string of question;
 *  Ans      - right answer on the question;
 *  Key      - answer that gave user.
 * If Key = Ans, predicate adds clause right(Quest, Key) to database. 
 * Else predicate adds clause wrong(Quest, Key) to database.
 * In order to add clause to database we use embedded predicate
 * assertz, for example:
 *   assertz(right(Quest, Key))
 *
 * With facts in a dynamic database, you can work as with standard
 * facts, in particular, you can refer to them from other predicates.
 */
     
nondeterm right_list(integer)
/* Predicate sorts out all clauses ‘right’, prints each of
 * them on the screen and returns amount of them. 
 * In order to consider each clause only one time, after
 * processing each clause can be deleted from database with
 * embedded predicate ‘retract’, for example: 
 *   retract(right(Quest, Key)) */
    
nondeterm wrong_list(integer)
/* Predicate sorts out all clauses ‘wrong’ prints each of
 * them on the screen and returns amount of them. */
   
nondeterm summarize
/* Predicate displays list of right answered questions,
 * wrong answered questions and percentage
 * of right answers on the screen. */
  
clauses

data("2+2=4?", 'y').
data("Собака ЯвлЯетсЯ парнокопытным?", 'n').
data("Я живу в Москве?", 'n').
data("У менЯ есть машина?", 'n').
data("Мне 20 лет?", 'y').
data("Я студент?", 'y').
data("Я уже сдал сессию?", 'n').
data("Я нахожусь в России?", 'y').
  
process(Quest, Ans):- write(Quest), readchar(Key), write(Key), nl,
    updatebase(Quest, Ans, Key).
  
updatebase(Quest, Ans, Key):- Key = Ans, assertz(right(Quest, Key)), !.
updatebase(Quest, Ans, Key):- assertz(wrong(Quest, Key)).
  
right_list(Count1):- right(Quest, Key), retract(right(Quest, Key)),
    write(Quest), write(Key), nl, right_list(Count), Count1 = Count + 1; Count1 = 0.
wrong_list(Count2):- wrong(Quest, Key), retract(wrong(Quest, Key)),
    write(Quest), write(Key), nl, wrong_list(Count), Count2 = Count + 1; Count2 = 0.
  
summarize :- 
    nl, write("Right answered questions:"), nl,
    right_list(RightNumber), 
    nl, write("Wrong answered questions:"), nl,
    wrong_list(WrongNumber), 
    Accuracy = RightNumber / (RightNumber + WrongNumber), 
    writef("Accuracy of answers = %3.0f%%", Accuracy), nl.
  
goal

write("Вы интересуетесь сведениЯми о студенте Наймушине Дмитрии кафедры ИУ-3"), nl,
write("'Информационные системы и телекоммуникации' группы ИУ3-71"), nl, 
write("Отвечайте 'да' или 'нет' на задаваемые вам вопросы (y/n)"), nl, fail;
data(Quest, Ans), process(Quest, Ans), fail;
summarize.