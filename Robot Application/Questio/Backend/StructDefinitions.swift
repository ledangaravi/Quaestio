//
//  StructDefinitions.swift
//  Questio
//
//  Created by Rahul Berry on 23/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//
public struct cvData{
    var Mood = ""
    var Age = 0
    var Gender = ""
    var Bracket = ""
}

public struct questionData {
    var optOne = ""
    var optTwo = ""
    var optThree = ""
    var optFour = ""
    var optFive = ""
    var format = ""
    var Question = ""
    var QuestionNum = ""
    
}

public struct config_data{
    var Data_Notice = false
    var Experiment_Type = ""
    var Face_Type = ""
    var Hypothesis = ""
    var Personal_Limit = 0
    var Personal_Timed = false
    var Privacy_Code = false
    var Short_Limit = 50
    var Short_Timed = false
    var Time_Creted = ""
    var Title = ""
    var shuffled = false
    var surveySetID = ""
    var surveyID = ""
    var Current_Question = ""
}
