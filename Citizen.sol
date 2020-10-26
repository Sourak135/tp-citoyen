// SPDX-License-Identifier: MIT              
pragma solidity ^0.6.0; 
pragma experimental ABIEncoderV2;

contract Citizen{
    
//structure des citoyens        
    struct Citoyen{
        bool citoyen; // a reflechir
        uint256 id;
        uint256 wallet; // argent possédé
        bool travailleur;
        bool chomeur;
        uint256 cotisation_chomeur;
        bool malade;
        uint256 cotisation_maladie;
        bool retraite;
        uint256 cotisation_retraite;
        uint8 age; // a remplir lors register pour prevoir la retraite
        bool banni; //banni 10 ans?
        //bool mort; //pas sur utile et trop de lignes pour que ça passe avec

    }
    
// strucuture des sages - trop de lignes si intégré a Citoyen   
    struct Sage{
        bool isSage;
        uint256 depot_sage;
        uint256 delayRegistration; //sage pdt 8 semaines =  block.timestamp + 8 weeks
    }

//structure des entreprises    
    struct Entreprises{
        uint256 id; // siret
        uint256 argent;
        bool statut; //statut valide?
    }


// id pour ne pas avoir deux citoyens avec id identiques    
    uint256 public _id;
//budget, incrémenté par impots, amendes, décès; décrémenté par nouveaux citoyens et entreprises   
    uint256 public budget;
    string public help_gestion_status = "change le status 0=travailleur, 1=chomeur, 2=malade, 3=mort";
    enum statut { travailleur, chomeur, malade, mort }
    
    mapping (address => Citoyen ) public administration;
    mapping (address => Sage ) public admin;
    mapping (address => Entreprises ) public travail;

modifier onlySage (){
            require (admin[msg.sender].isSage == true, "only Sage can do this");
            require(admin[msg.sender].delayRegistration > block.timestamp, "vous n'êtes plus sage");
            _;
        }
    
// enregistrement de nouveau citoyen, vérif pas déjà citoyen, attribue citoyenneté, id, 100 citizen (retirés au budget), incrémente id général     
    function register(address _addr) public onlySage{
        require (administration[_addr].citoyen==false, "cette personne est déjà citoyen");
        administration[_addr].citoyen=true;
        administration[_addr].id=_id+1;
        administration[_addr].wallet+=100;
        budget-=100;
        _id+=1;
    }
    
//gestion de statut par sage  0 travailleur, 1 chomeur, 2, malade, 3mort     
    function gestion_statut(statut _ide, address _addr) public onlySage {
        if (_ide==statut.travailleur){
            administration[_addr].travailleur?administration[_addr].travailleur=false:administration[_addr].travailleur=true;
        }
        else if (_ide==statut.chomeur){
            administration[_addr].chomeur?administration[_addr].chomeur=false:administration[_addr].chomeur=true;
        }
        else if (_ide==statut.malade){
            administration[_addr].malade?administration[_addr].malade=false:administration[_addr].malade=true;
        }
        else if (_ide==statut.mort){
            budget+=administration[_addr].wallet;
            administration[_addr].wallet=0;
            budget+=administration[_addr].cotisation_chomeur;
            administration[_addr].cotisation_chomeur=0;
            budget+=administration[_addr].cotisation_maladie;
            administration[_addr].cotisation_maladie=0;
            budget+=administration[_addr].cotisation_retraite;
            administration[_addr].cotisation_retraite=0;
        }
    }
   
    
    
    
    
}
    