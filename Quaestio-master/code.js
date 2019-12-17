// JavaScript Document


var fetch = document.getElementById("SurveyID");
var Button =document.getElementById("submitButton")
var pathRoot="Data/";
var input;
var DeletePath="NothingToDelete";

function submitClick(){
	input=fetch.value;
	
	var dict = {
	"QP1" :"How old are you?",
    "QP10": "How physically healthy do you consider yourself?",
    "QP11" : "Do you have any history of mental health illness in your family?",
    "QP12" :"How often do you smoke?",
    "QP13" : "How important is sex to you?",
    "QP14" :"How many different people have you had sex with?",
    "QP15" :"How would you rate yourself in bed?",
    "QP16" :"Have you ever had an STD?",
    "QP17" :"What is your opinion on Brexit?",
    "QP18" :"Who are you voting for in the upcoming UK general election? ",
    "QP19" :"My last question is, what how do you feel about this survey experience?",
    "QP2" :"In a typical day, how many of your meals include vegetables?",
    "QP3" :"How important is your health to you?",
    "QP4" :"In a typical week, how often do you exercise?",
    "QP5" :"How do you exercise?",
    "QP6" :"What time of day do you usually exercise?",
    "QP7" :"How long do you usually exercise for?",
    "QP8" :"Do you go to the gym?",
    "QP9" :"Would you say you eat a healthy balanced diet?",
    "Q1" :"Have you heard any news about robots recently?",
    "Q10" :"Would you use a robot vacuum cleaner?",
    "Q11" :"In how many years do you think using robot vacuum cleaners will be the norm?",
    "Q12" :"Do you think that robots will be self-aware one day?",
    "Q13" :"If robots were self-aware, do you think they would deserve basic rights?",
    "Q14" :"How many times have you interacted with a humanoid robot?",
    "Q15" :"Do you believe that robots and automation will result in job loss? ",
    "Q16" :"Are you afraid robots will take over your job some day? ",
    "Q17" :"Do you think that automating more jobs is the correct way forward?",
    "Q18" :"Should robots fulfil law-enforcement occupations?",
    "Q19" :"Should robots fulfil teaching occupations?",
    "Q2" :"Do you own a home personal assistant or conversational agent, such as Alexa?",
    "Q20" :"Would you prefer automated grading in schools by AIs?",
    "Q21" :"Would you fly on an autonomous airplane?",
    "Q22" : "Would you eat food prepared by robots? ",
    "Q23" :"How would you feel about robot restaurant waiters?",
    "Q24" :"Would you have your hair done by a robot?",
    "Q25" :"Would you undergo a surgery performed by a robot?",
    "Q26" :"Should governments increase funding for the development of robot technology?",
    "Q27" :"Should certain governments pay more attention and spend more in governing and building the robotics industry than others?",
    "Q28" :"Do you believe that robotics and AI development is dangerous? ",
    "Q29" :"Should the general public be able to buy personal robots? ",
    "Q3" : "How often do you interact with chatbots?",
    "Q30" :"Would you ever want to own a personal robot?",
    "Q31" :"Would you have a robot pet?",
    "Q32" :"Do you prefer interacting with robots and digital platforms rather than people when possible? ",
    "Q33" :"Do you think robots are a valuable asset for humans?",
    "Q34" :"In 100 years, what do you think will be the ratio of robots to humans?",
    "Q35" :"How much do you agree with the following statement? I believe robots will have a positive impact on our future",
    "Q36" :"How much do you agree with the following statement? If a robot talked like a human, I would be confident interacting with it",
    "Q37" :"How much do you agree with the following statement? Technology is going to solve many of our greatest issues",
    "Q38" :"How much do you agree with the following statement? I think using robots in elderly care is a good idea",
    "Q39" :"How much do you agree with the following statement? I am afraid robots might one day take over humanity",
    "Q4" :"What gender do you think an AI should be?",
    "Q40" :"Would you leave your child in a robot’s care for more than an hour unattended?",
    "Q41" : "Would you trust a robot to take care of your dog?",
    "Q42" : "Would you be willing to share personal matters and topics with a robot?",
    "Q5" : "Do you think robots should be humanoid?",
    "Q6" : "Should robots be able to detect and recognise emotions?",
    "Q7" : "Do you feel robots have had an impact on your life?",
    "Q8" : "Do you think humans will become increasingly dependent on robots?",
    "Q9" : "How many robots do you own?",
	};
	
	var database = firebase.database();
var ref=database.ref(pathRoot);
ref.on('value',gotData, errData);

function gotData(data){
	if (data.val() == null) {
		myList.innerHTML ='<li></li>';
		return;	
	}
	var storage; //Variable to save 
	var array=[];
	var Survey = data.val();
	var path="NoPath";
	var keys =Object.keys(Survey);
	for (i=0;i<keys.length;i++){
		//console.log("DataWebTest/"+keys[i]+"/");
		var Longstring=database.ref(pathRoot+keys[i]);
		Longstring.on('value',function(snapshot){
			storage=snapshot.val()});
			var code=Object.keys(storage);
			for(j=0;j<code.length;j++){
				if(input==code[j]){
					path=pathRoot+keys[i]+"/"+input;
					console.log(path);
				}
				else{
				}
			}
	}
	if(path=="NoPath"){
		window.alert("No Survey Found");
		return;	
				}
	
	var Answers=database.ref(path);
	Answers.on('value',function(snapshot){
		storage=snapshot.val();});
	var Answers= Object.keys(storage);
	for (i=0;i <Answers.length;i++){
		var j=0;
		var NQ=Answers[i];
		var AQ=storage[Answers[i]].Response;
		if(NQ.charAt(0)=='Q'){
			array.push(dict[NQ]+": "+AQ);
			j = j+1;
		}
	}
	myList.innerHTML ='<li>'+array.join('</li><li>')+'</li>';
	DeletePath=path;

	Answer.innerHTML="Answers";
	Delete.innerHTML="Click here to Delete Your Data";
	console.log(DeletePath);
	return(DeletePath);
	}	
};
function errData(data){
	console.log('Err');
	console.log(err);
	
};

	

function submitDelete(){
	if (DeletePath=="NothingToDelete"){
	window.alert("Nothing To Delete");
	}
	else{
		console.log(DeletePath);
		firebase.database().ref(DeletePath).remove()
		window.alert("Data Deleted");
		location.reload(true)
		path="NoPath";
	}
};
