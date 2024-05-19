#include <iostream>
#include <stdlib.h>
using namespace std;

struct planeta{
    string ambiente;
    int oxigeno;
    planeta *prxpl;
    };
    struct planeta *ap,*bp,*ep;

struct alien{
    string especie;
    int salud;
    int energia;
    string ambiente;
     alien *prxl;
    };
    struct alien *al,*bl,*el;

struct acceso{
    string nacceso;
    int salper;//ataque
    int energas;
    int impred;//defensa
    int salrest;//supervivencia
    int enerest;
    int oxigeno; //adaptacion
    struct acceso *prxacc;
    };
    struct acceso *ac,*bc, *ec;

struct solds{
    string alumno;
    string especie;
    int salud;
    int energia;
    string ambiente;
    struct acceso mochila[5];
    struct solds *prxsol;
    };
    struct solds *as,*bs,*es;

//Parte(Ambiente)
void agg_amb(string amb, int ox){
    if(ap==NULL){
        ap=new planeta;
        ap->ambiente=amb;
        ap->oxigeno=ox;
        bp=ap;
        ep=ap;}
    else{
        ap=new planeta;
        ap->ambiente=amb;
        ap->oxigeno=ox;
        ep->prxpl=ap;
        ep=ep->prxpl;}
    ep->prxpl=NULL;
}

void mos_amb(){
    cout<<".-.-.-.-.-LISTA DE AMBIENTES.-.-.-.-"<<endl;
    ap=bp;
    while(ap!=NULL){
        cout<<"Planeta:"<<" "<<ap->ambiente<<" "<<"Oxigeno:"<<ac->oxigeno<<endl;
        ap=ap->prxpl;
    }
}

int busc_amb(string amb){ //, int ox
    ap=bp;
    while(ap!=NULL){
        if(ap->ambiente!=amb){ // && al->oxigeno!=ox
            ap=ap->prxpl;}
        else{
            return 1;}
    }
    return 0;
}

int valid_amb(string amb){
  for (int i = 0; i < 20; i++) {
    if (amb[i] < 'A' || amb[i] > 'Z') {
      return 0;
    }
  }
  return 1;
}

void elim_amb(string amb){
    if(busc_amb(amb)==1){
        struct planeta *zp,*xp=NULL; 
        zp = bp;
        while (zp!=NULL && zp->ambiente!=amb){
            xp = zp;
            zp = zp->prxpl;}
        
            if (zp == bp){
                bp=bp->prxpl;}
            else{
                xp->prxpl = zp->prxpl;
             delete (zp);
             cout<<"Su ambiente ha sido eliminado con exito"<<endl;}  
           }        

    if(busc_amb(amb)==0){
        cout<<"No puedes eliminar un ambiente que no existe"<<endl;
    }
}

void mod_amb(){
    string amb, ambx;
    int oxx;
    int wamo1=0, wamo2=0, wamo3=0;
    while(wamo3<1){
        cout<<"Indique el nombre del ambiente que desea modificar"<<endl;
        cout<<"Recuerda ingresarlo correctamente"<<endl;
        cin>>amb;
        if(busc_amb(amb)==1){
            while(wamo2<1){
                cout<<"Indique el nuevo nombre del planeta"<<endl;
                cin>>ambx;
                if(valid_amb(amb)==1){
                    ap->ambiente=ambx;
                    while(wamo1<1){
                        cout<<"Indique el nuevo nivel de oxigeno de su ambiente"<<endl;
                        cin>>oxx;
                        if(oxx>70 && oxx<100){
                            ap->oxigeno=oxx;
                            cout<<"Su ambiente se modifico con exito"<<endl;
                            wamo1=1;
                            wamo2=1;
                            wamo3=0;}
                        else{
                            cout<<"Los valores validos para el oxigeno son del 70-100"<<endl;
                            cout<<"Intenta de nuevo..."<<endl;}
                    }
                }

                else{
                    cout<<"Tip: Recuerda escribirlo en mayusculas"<<endl;
                    cout<<"Intenta de nuevo..."<<endl;}
            }
        }
    }      
}

int submenu_amb(){
    int submap;
    cout<<".-.-.OPCIONES DE AMBIENTES.-.-."<<endl;
    cout<<".-.-.-..-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"1. Agregar un ambiente-.-.-.-.-"<<endl;
    cout<<"2. Modificar un ambiente-.-.-.-."<<endl;
    cout<<"3. Eliminar un ambiente-.-.-.-."<<endl;
    cout<<"4. Consultar ambientes-.-.-.-.-"<<endl;
    cout<<"5. Regresar-.-.-.-.-.-.-.-.-.-."<<endl;
    cout<<"-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cin>>submap;
    return submap;

}

void default_amb(){
    agg_amb("BOCCANONG", 70);
    agg_amb("AUREOLERNO", 71);
    agg_amb("PIRULIN", 72);
    agg_amb("XORBE", 73);
    agg_amb("CENIAHT", 74);
    agg_amb("TIERRA", 75);
    agg_amb("ANDROMEDA",76);
}
void mos_alien(){
    cout<<".-.-.-.-.-LISTA DE ESPECIES.-.-.-.-"<<endl;
    al=bl;
    while(al!=NULL){
        cout<<"Especie:"<<al->especie<<" "<<"Salud:"<<al->salud<<" "<<"Energia"<<al->energia<<" "<<"Ambiente:"<<al->ambiente<<endl;
        al=al->prxl;
    }
}
//(Parte de Alien)
void ins_alien(string amb, string esp, int hp, int sp){
    if(al==NULL){
        al=new alien;
        al->ambiente=amb;
        al->especie=esp;
        al->salud=hp;
        al->energia=sp;
        bl=al;
        el=al;}
    else{
        al=new alien;
        al->ambiente=amb;
        al->especie=esp;
        al->salud=hp;
        al->energia=sp;
        el->prxl=al;
        el=el->prxl;}
    el->prxl=NULL;
}    

void default_alien(){
    ins_alien("BOCCANONG",    "Ceronivas",      60,  100);    //Ambiente, Especie, Salud, Energia
    ins_alien("AUREOLERNO",   "Demoniangeles",  65,   85);
    ins_alien("PIRULIN",      "Yublin",         100,  55);
    ins_alien("XORBE",        "Ebrax",          65,   65);
    ins_alien("CENIAHT",      "Tranolah",       78,   68);
    ins_alien("TIERRA",       "Humano",         80,   70);
    ins_alien("ANDROMEDA",    "Andromedano",    70,   80);
}

int busc_alien(string esp){
    al=bl;
    while(al!=NULL){
        if(al->especie!=esp){
            al=al->prxl;}
        else{
            return 1;}
    }
    return 0;
}

int valid_hsp(int hp, int sp){
    if(hp>100 || sp>100){
        return 0;}
    else{
        return 1;}
}

void mod_alien(string esp){
    string espx, ambx;
    int hpx, spx, wal3=0, wal4=0;
    if(busc_alien(esp)==1){
        while(wal4<1){
            cout<<"Selecciona el nuevo planeta para tu especie:"<<endl;
            cout<<"Tip: Recuerda escribir todo en MAYUSCULAS"<<endl;
            mos_amb();
            cin>>ambx;
            if(busc_amb(ambx)==1){
                al->ambiente=ambx;
                cout<<"Indique el nuevo nombre de la especie:"<<endl;
                cin>>espx;
                al->especie=espx;
                while(wal3<1){
                cout<<"Indique la nueva cantidad de salud de la especie (1-100):"<<endl;
                cin>>hpx;
                cout<<"Indique la nueva cantidad de energia de la especie (1-100):"<<endl;
                cin>>spx;
                if(valid_hsp(hpx, spx)==1){
                    al->energia=spx;
                    al->salud=hpx;
                    cout<<"Su especie ha sido modificada con exito"<<endl;
                    wal3=1;
                    wal4=1;}
                else{
                    cout<<"El valor ingresado, excede el límite establecido"<<endl;
                    cout<<"Intente de nuevo..."<<endl;}}
            }
            else{
                cout<<"La especie seleccionada no existe o esta ingresada erroneamente"<<endl;
                cout<<"Intente de nuevo..."<<endl;}
        }
    }
}
void elim_alien(string esp){
    if(busc_alien(esp)==1){
        struct alien *zl,*xl=NULL; 
        zl = bl;
        while (zl!=NULL && zl->especie!=esp){
            xl = zl;
            zl = zl->prxl;}
        
            if (zl == bl){
                bl=bl->prxl;}
            else{
                xl->prxl = zl->prxl;
             delete (zl);
             cout<<"Su especie ha sido eliminada con exito"<<endl;}  
           }         

    else{
        cout<<"No puedes eliminar una especie que no existe"<<endl;
    }
}

int submenu_aliens(){
    int submal;
    cout<<".-.-.-.-.-OPCIONES DE ESPECIES.-.-.-.-.-.-"<<endl;
    cout<<".-.-.-..-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cout<<"1. Agregar una especie-..-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"2. Modificar una especie.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"3. Eliminar una especie-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"4. Mostrar especies.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cout<<"5. Regresar-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<".-.-.-..-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cin>>submal;
    return submal;

}

//(Parte de Accesorios)

int submenu_acceso(){
    int submac;
    cout<<"-.-.-GESTION DE ACCESORIOS-.-.-.-"<<endl;
    cout<<".-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cout<<"1. Crear Nuevo Accesorio-.-.-.-.-"<<endl;
    cout<<"2. Modificar Accesorio.-.-.-.-.-."<<endl;
    cout<<"3. Eliminar Accesorio.-.-.-.-.-.-"<<endl;
    cout<<"4. Mostrar Accesorios-.-.-.-.-.-."<<endl;
    cout<<"5. Regresar-.-.-.-.-.-.-..-.-.-.-"<<endl;
    cout<<".-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cin>>submac;
    return submac;
}

int submenu_accrear(){
    int submacr;
    cout<<".-.-.-..-.-.-.-.-.-.-.-.-.CREACION DE ACCESORIOS-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<".-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cout<<"1. Accesorio de Ataque (Consume energia)-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"2. Accesorio de Defensa (Se usan solo una vez).-.-.-.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cout<<"3. Accesorio de Supervivencia (Regeneran salud y/o energia).-.-.-.-.-.-.-.-"<<endl;
    cout<<"4. Accesorio de Adaptacion (Te permite combatir en distintos ambientes)-.-."<<endl;
    cout<<".-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cin>>submacr;
    return submacr;
}

void ins_acceso(string nac, int hpp, int spg, int dr, int hpr, int spr, int ox){
    if(ac==NULL){
        ac=new acceso;
        ac->nacceso=nac;
        ac->salper=hpp;
        ac->energas=spg;
        ac->impred=dr;
        ac->salrest=hpr;
        ac->enerest=spr;
        ac->oxigeno=ox;
        bc=ac;
        ec=ac;}
    else{
        ac=new acceso;
        ac->nacceso=nac;
        ac->salper=hpp;
        ac->energas=spg;
        ac->impred=dr;
        ac->salrest=hpr;
        ac->enerest=spr;
        ac->oxigeno=ox;
        ec->prxacc=ac;
        ec=ec->prxacc;}
    ec->prxacc=NULL;
}

void crea_acceso(){
    string nac;
    int hpp,spg,dr,hpr,spr,ox;
    int submacr, wac1=0, wac2=0, wac3=0, wac4=0;
    cout<<"Que tipo de accesorio desea crear"<<endl;
    submacr=submenu_accrear();
    switch(submacr){
        case 1:
        cout<<"Dale nombre a tu nueva arma de destruccion"<<endl;
        cin>>nac;
        while(wac1<1){
            cout<<"Indique la energia que consumira su accesorio de ataque"<<endl;
            cin>>spg;
            cout<<"Indique la hemorragia que hara su nuevo accesorio de ataque"<<endl;
            cin>>hpp;
            if(spg>100||hpp>100){
                cout<<"Uno o ambos valores exceden el limite establecido"<<endl;
                cout<<"Por favor intenta de nuevo..."<<endl;
            }
            else{
            //Se convierten el resto de valores a "0" para volverlo unicamente de ataque.
            dr=0, hpr=0, spr=0,ox=0;
            ins_acceso(nac, hpp, spg, dr, hpr, spr, ox);
            cout<<"Su accesorio fue creado con exito"<<endl;
            wac1=1;
            }
        }
        break;
        
        case 2:
        cout<<"Dale nombre a tu nuevo componente defensivo"<<endl;
        cin>>nac;
        while(wac2<0){
            cout<<"Indique el porcentaje que reducira tu artefacto del dano enemigo"<<endl;
            cin>>dr;
            if(dr>70){
                cout<<"El valor excede el limite establecido"<<endl;
                cout<<"Por favor intenta de nuevo..."<<endl;}
            else{
                //Se convierten el resto de valores a "0" para volverlo unicamente de defensa.
                hpp=0,spg=0,hpr=0,spr=0,ox=0;
                ins_acceso(nac, hpp, spg, dr, hpr, spr, ox);
                cout<<"Su accesorio fue creado con exito"<<endl;
                wac2=1;}
        }
        break;
        
        case 3:
        cout<<"Dale nombre a tu futuro botiquin de primeros auxilios"<<endl;
        cin>>nac;
        while(wac3){
            cout<<"Indique que tantos puntos de salud restaurara (puedes poner que 0, digo si quieres que el juego sea equilibrado)"<<endl;
            cin>>hpr;
            cout<<"Indique que tantos puntos de energia restaurara"<<endl;
            cin>>spr;
            if(hpr>100||spr>100){
                cout<<"Uno o ambos valores exceden el limite establecido"<<endl;
                cout<<"Por favor intenta de nuevo..."<<endl;}
            else{    
                //Se convierten el resto de valores a "0" para volverlo unicamente de supervivencia.
                hpp=0,spg=0,dr=0,ox=0;
                ins_acceso(nac, hpp, spg, dr, hpr, spr, ox);
                cout<<"Su accesorio fue creado con exito"<<endl;
                wac3=1;}
        }
        break;

        case 4:
        cout<<"Dale nombre a tu primordial requisito para no morir fuera de tu planeta"<<endl;
        cin>>nac;
        mos_amb();
        while(wac4){
            cout<<"Para adaptarte al ambiente que deseas, ingresa su nivel de oxigeno (nO2):"<<endl;
            cin>>ox;
            if(ox<70 || ox>100){
                cout<<"El valor excede (o es inferior) el limite establecido"<<endl;
                cout<<"Por favor intenta de nuevo..."<<endl;}
            else{
                //Se convierten el resto de valores a "0" para volverlo unicamente de adaptacion.
                hpp=0,spg=0,dr=0,hpr=0,spr=0;
                ins_acceso(nac, hpp, spg, dr, hpr, spr, ox);
                cout<<"Su accesorio fue creado con exito"<<endl;
                wac4=1;}
        }
        break;
        }
        

}



void mos_acceso(){
    ac=bc;
    while(ac!=NULL){
        cout<<ac->nacceso<<" "<<ac->salper<<" "<<ac->energas<<" "<<ac->impred<<
        ac->salrest<<" "<<ac->enerest<<" "<<ac->oxigeno<<" "<<endl;
        ac=ac->prxacc;
    }
}


int busc_acceso(string nac){ //, int hpp, int spg, int dr, int hpr, int spr, int ox
    ac=bc;
    while(ac!=NULL){
        if(ac->nacceso!=nac){ // && ac->salper!=hpp && ac->energas!=spg && ac->impred!=dr && ac->salrest!=hpr &&... 
            ac=ac->prxacc;}
        else{
            return 1;}
    }
    return 0;
}


void mod_acceso(string nac){
    string nacx;
    int hppx,spgx,drx,hprx,sprx,oxx,submacr;
    int wacm1=0, wacm2=0, wacm3=0, wacm4=0;
    if(busc_acceso(nac)==1){
        cout<<"Deseas convertir su accesorio a un tipo especifico (supervivencia, adaptacion,etc...)"<<endl;
        submacr=submenu_accrear();
        switch(submacr){
            case 1:
            cout<<"Dale nombre a tu renovada arma de destruccion"<<endl;
            cin>>nacx;
            ac->nacceso=nacx;
            while(wacm1<1){
                cout<<"Indique la energia que consumira su accesorio de ataque"<<endl;
                cin>>spgx;
                cout<<"Indique la hemorragia que hara su accesorio de ataque"<<endl;
                cin>>hppx;
                if(spgx>100||hppx>100){
                    cout<<"Uno o ambos valores exceden el limite establecido"<<endl;
                    cout<<"Por favor intenta de nuevo..."<<endl;}
                else{
                    ac->energas=spgx;
                    ac->salper=hppx;
                    //Se convierten el resto de valores a "0" para volverlo unicamente de ataque.
                    drx=0, hprx=0, sprx=0,oxx=0;
                    ac->impred=drx;
                    ac->salrest=hprx;
                    ac->enerest=sprx;
                    ac->oxigeno=oxx;
                    cout<<"Su accesorio fue modificado con exito"<<endl;
                    wacm1=1;}    
            break;
            case 2:
            cout<<"Dale nombre a tu nuevo componente defensivo"<<endl;
            cin>>nacx;
            ac->nacceso=nacx;
            while(wacm2<1){
                cout<<"Indique el porcentaje que reducira tu artefacto del dano enemigo"<<endl;
                cin>>drx;
                if(drx>70){
                    cout<<"El valor excede el limite establecido"<<endl;
                    cout<<"Por favor intenta de nuevo..."<<endl;}
                else{
                    ac->impred=drx;
                    //Se convierten el resto de valores a "0" para volverlo unicamente de defensa.
                    hppx=0,spgx=0,hprx=0,sprx=0,oxx=0;
                    ac->salper=hppx;
                    ac->energas=spgx;
                    ac->salrest=hprx;
                    ac->enerest=sprx;
                    ac->oxigeno=oxx;
                    cout<<"Su accesorio fue modificado con exito"<<endl;
                    wacm2=1;}    
            }
            break;

            case 3:
            cout<<"Dale nombre a tu futuro botiquin de primeros auxilios"<<endl;
            cin>>nacx;
            ac->nacceso=nacx;
            while(wacm3<1){
                cout<<"Indique que tantos puntos de salud restaurara (puedes poner que 0, digo si quieres que el juego sea equilibrado)"<<endl;
                cin>>hprx;
                cout<<"Indique que tantos puntos de energia restaurara"<<endl;
                cin>>sprx;
                if(hprx>100||sprx>100){
                    cout<<"Uno o ambos valores exceden el limite establecido"<<endl;
                    cout<<"Por favor intenta de nuevo..."<<endl;}
                else{
                    ac->salrest=hprx;
                    ac->enerest=sprx;
                    //Se convierten el resto de valores a "0" para volverlo unicamente de supervivencia.
                    hppx=0,spgx=0,drx=0,oxx=0;
                    ac->salper=hppx;
                    ac->energas=spgx;
                    ac->impred=drx;
                    ac->oxigeno=oxx;
                    cout<<"Su accesorio fue modificado con exito"<<endl;
                    wacm3=1;}
                
            }
            break;

            case 4:
            cout<<"Dale nombre a tu primordial requisito para no morir fuera de tu planeta"<<endl;
            cin>>nacx;
            ac->nacceso=nacx;
            mos_amb();
            while(wacm4<1){
                cout<<"Para adaptarte al ambiente que deseas, ingresa su nivel de oxigeno (nO):"<<endl;
                cin>>oxx;
                if(oxx<70 || oxx>100){
                    cout<<"El valor excede (o es inferior) el limite establecido"<<endl;
                    cout<<"Por favor intenta de nuevo..."<<endl;}
                else{
                    ac->oxigeno=oxx;
                    //Se convierten el resto de valores a "0" para volverlo unicamente de adaptacion.
                    hppx=0,spgx=0,drx=0,hprx=0,sprx=0;
                    ac->salper=hppx;
                    ac->energas=spgx;
                    ac->impred=drx;
                    ac->salrest=hprx;
                    ac->enerest=sprx;
                    cout<<"Su accesorio fue modificado con exito"<<endl;
                    wacm4=1;}
            }
            break;
            }
        }
    }    

    else{
        cout<<"No puedes modificar un accesorio que no existe"<<endl;
        cout<<"Recuerda ingresar su nombre correctamente"<<endl;}
       
}

void elim_acceso(string nac){
    if(busc_acceso(nac)==1){
        struct acceso *zc,*xc=NULL; 
        zc = bc;
        while (zc!=NULL && zc->nacceso!=nac){
            xc = zc;
            zc = zc->prxacc;}
        
            if (zc == bc){
                bc=bc->prxacc;}
            else{
                xc->prxacc = zc->prxacc;
             delete (zc);
             cout<<"Su accesorio fue eliminado con exito"<<endl;}  
           }      

    if(busc_alien(nac)==0){
        cout<<"No puedes eliminar un accesorio que no existe"<<endl;
    }
}

void default_acceso(){
    ins_acceso("TERMOGUANTE",   10,  10,  0,   0,  0,   0);  //Accesorios de Ataque
    ins_acceso("BALAZUL",       20,  20,  0,   0,  0,   0);
    ins_acceso("AREPALO",       15,  15,  0,   0,  0,   0);
    ins_acceso("PIROMARTILLO",  40,  35,  0,   0,  0,   0);
    ins_acceso("GRANALTAR",     30,  30,  0,   0,  0,   0);
    ins_acceso("MINIBARRERA",    0,  0,   2,   0,  0,   0);  //Accesorios de Defensa
    ins_acceso("BLANDARRERA",    0,  0,   5,   0,  0,   0);
    ins_acceso("ESCUDOCHIX",     0,  0,   10,  0,  0,   0);
    ins_acceso("CORTAQUE",       0,  0,   50,  0,  0,   0);
    ins_acceso("CFI",            0,  0,   100, 0,  0,   0);
    ins_acceso("PILDOVIDA",      0,  0,   0,   20, 0,   0);  //Accesorios de Supervivencia
    ins_acceso("PILDOENERGIA",   0,  0,   0,   0,  20,  0);
    ins_acceso("SUPILDOVIDA",    0,  0,   0,   30, 0,   0);
    ins_acceso("PILDOVIDA",      0,  0,   0,   0,  30,  0);
    ins_acceso("PILDOMIXTA",     0,  0,   0,   10, 10,  0);
    ins_acceso("SUPILDOMIXTA",   0,  0,   0,   10, 10,  0);
    ins_acceso("BOCCAVELLA",     0,  0,   0,   0,  0,   70); //Accesorios de Adaptacion
    ins_acceso("ALICUERNO",      0,  0,   0,   0,  0,   71);
    ins_acceso("TINTIN",         0,  0,   0,   0,  20,  72);
    ins_acceso("XIERBA",         0,  0,   0,   0,  0,   73);
    ins_acceso("CERESIANO",      0,  0,   0,   0,  0,   74);
    ins_acceso("ODOS",           0,  0,   0,   0,  0,   75);
    ins_acceso("ANDROGAFAS",     0,  0,   0,   0,  0,   76);
}

//Parte(Soldados/Estudiantes)
int submenu_solds(){
    int submsol;
    cout<<".-.-.-..-.-.-OPCIONES DE SOLDADOS.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<".-.-.-..-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"1. Agregar un soldado-..-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"2. Modificar un soldado.-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"3. Eliminar un soldado-.-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"4. Agregar Objetos a la mochila de un soldado.-.-.-"<<endl;
    cout<<"5. Modificar un slot de la mochila de un soldado.-."<<endl;
    cout<<"6. Eliminar un slot de la mochila de un soldado.-.-"<<endl;
    cout<<"7. Regresar-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cout<<".-.-.-..-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cin>>submsol;
    return submsol;

}

void agg_solds(){
    string aluma,esp;
    cout<<"Escoja la raza del soldado que desea agregar:"<<endl;
    cout<<"(Escribe tal cual el nombre de la raza)"<<endl;
    mos_alien();
    cin>>esp;
    if(busc_alien(esp)==1){
        if(as==NULL){
            as=new solds;
            as->especie=al->especie;
            as->salud=al->salud;
            as->energia=al->energia;
            as->ambiente=al->ambiente;
            bs=as;
            es=as;}
        else{
            as=new solds;
            as->especie=al->especie;
            as->salud=al->salud;
            as->energia=al->energia;
            as->ambiente=al->ambiente;
            es->prxsol=as;
            es=es->prxsol;}
        cout<<"Ingresa el nombre del alumno"<<endl;
        cin>>aluma;
        as->alumno=aluma;
        es->prxsol=NULL;}
    else{
        cout<<"Por favor... Escribe correctamente el nombre sin ignorar mayusculas"<<endl;
        cout<<"(Tambien puede ser que no exista la raza de la que hablas...)"<<endl;
        submenu_solds();
    }
}

int busc_solds(string aluma){ //, int salud, int energia, string ambiente
    as=bs;
    while(as!=NULL){
        if(as->alumno!=aluma){ // && al->salud!=hp && al->energia!=hp && al->ambiente!=amb
            as=as->prxsol;}
        else{
            return 1;}
    }
    return 0;
}

void mos_solds(){
    as=bs;
    while(as!=NULL){
        cout<<as->alumno<<" "<<as->especie<<" "<<as->salud<<" "<<as->energia<<
        as->ambiente<<endl;
        as=as->prxsol;
    }
}


void mod_solds(string alumn){
    string alumnx,esp;
    int submsol;
    if(busc_solds(alumn)==1){
        cout<<"Que deseas hacer con tu estudiante/soldado intergalactico"<<endl;
        cout<<"1. Modificar su nombre"<<endl;
        cout<<"2. Cambiarlo de raza"<<endl;
        cin>>submsol;
        switch(submsol){
            case 1:
            cout<<"Renombra a tu miembro del comando estelar"<<endl;
            cin>>alumnx;
            as->alumno=alumnx;
            cout<<"Se renombro su alumno con exito"<<endl;
            break;


            case 2:
            cout<<"Escoja la raza nueva raza de su soldado:"<<endl;
            cout<<"Tip: Escribe tal cual el nombre de la raza"<<endl;
            mos_alien();
            cin>>esp;
            if(busc_alien(esp)==1){
                as->especie=al->especie;
                as->salud=al->salud;
                as->energia=al->energia;
                as->ambiente=al->ambiente;}
            else{
                cout<<"Por favor... Escribe correctamente el nombre sin ignorar mayusculas"<<endl;
                cout<<"(Tambien puede ser que no exista la raza de la que hablas...)"<<endl;
                submenu_solds();
            }
            break;    
        }            
    }
}

void elim_solds(string alumn){
    if(busc_alien(alumn)==1){
        struct solds *zs,*xs=NULL; 
        zs = bs;
        while (zs!=NULL && zs->alumno!=alumn){
            xs = zs;
            zs = zs->prxsol;}
        
            if (zs == bs){
                bs=bs->prxsol;}
            else{
                xs->prxsol = zs->prxsol;
             delete (zs);
             cout<<"Su soldado fue eliminado con exito"<<endl;}  
           }      

    if(busc_alien(alumn)==0){
        cout<<"No puedes eliminar un soldado inexistente..."<<endl;
    }
}

void agg_mochila(string alumn){
    if(busc_solds(alumn)==1){
        int gsm=0,is=0;
        string nactx;
        while(gsm<5){
            mos_acceso();
            cout<<"Escribe el asesorio que deseas asignar al compartimiento"<<is<<"de tu soldado"<<endl;
            cout<<"Tip: Recuerda escribirlo correctamente y en mayusculas"<<endl;
            cin>>nactx;
            if(busc_acceso(nactx)==1){
                as->mochila[is].nacceso=ac->nacceso;
                as->mochila[is].salper=ac->salper;
                as->mochila[is].energas=ac->energas;
                as->mochila[is].impred=ac->impred;
                as->mochila[is].salrest=ac->salrest;
                as->mochila[is].enerest=ac->enerest;
                as->mochila[is].oxigeno=ac->oxigeno;
                is=is+1;
                gsm=gsm+1;}
            else{
                cout<<"No puedes agregarle accesorios que no existen"<<endl;
                cout<<"Recuerda escribirlo correctamente en mayusculas"<<endl;}
        }
        cout<<"La mochila de su soldado se ha llenado con exito"<<endl;
    
}

}

void mod_mochila(string alumn){
    if(busc_solds(alumn)==1){
        int is, msm1=0, msm2=0;
        string nactx;
        while(msm2<1){
        cout<<"Escoja el slot que desea modificar de la mochila"<<endl;
        cout<<"Valores validos del 1-5"<<endl;
        cin>>is;
            if(is!=1 || is!=2 || is!=3 || is!=4 || is!=5){
                cout<<"CIFRA INVALIDa..."<<endl;}
            else{
                while(msm1<1){
                    cout<<"Con que accesorio desea reemplazarlo?"<<endl;
                    mos_acceso();
                    cout<<"Recuerde ingresar en mayusculas y escribirlo correctamente"<<endl;
                    cin>>nactx;
                    if(busc_acceso(nactx)==1){
                        as->mochila[is].nacceso=ac->nacceso;
                        as->mochila[is].salper=ac->salper;
                        as->mochila[is].energas=ac->energas;
                        as->mochila[is].impred=ac->impred;
                        as->mochila[is].salrest=ac->salrest;
                        as->mochila[is].enerest=ac->enerest;
                        as->mochila[is].oxigeno=ac->oxigeno;
                        cout<<"El slot de su mochila se ha modificado con exito"<<endl;
                        msm1=1;
                        msm2=1;}
                    else{
                        cout<<"No puedes cambiar el contenido de un slot, por uno que no exista"<<endl;
                        cout<<"Verifica la lista de accesorios y escribe en MAYUS porfa"<<endl;} 
                }
            }
        }                   

    }
}


void elim_mochila(string alumn){
    if(busc_solds(alumn)==1){
        int is,esm=0;
        string nactx;
        while(esm<1){
            cout<<"Escoja el slot que desea eliminar de su mochila"<<endl;
            cout<<"Valores validos del 1-5"<<endl;
            cin>>is;
            if(is!=1 || is!=2 || is!=3 || is!=4 || is!=5){
                cout<<"CIFRA INVALIDA..."<<endl;}
            else{
                as->mochila[is].nacceso="";
                as->mochila[is].salper=0;
                as->mochila[is].energas=0;
                as->mochila[is].impred=0;
                as->mochila[is].salrest=0;
                as->mochila[is].enerest=0;
                as->mochila[is].oxigeno=0;
                cout<<"Se ha eliminado su slot de mochila con exito"<<endl;}
        }
    }
}

int menu_principal(){
    int mp;
    cout<<"-.-.-.-.-.-.-.-.-MENU PRINCIPAL INTERGALACTICO-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-..-.-.-.-.-.-.-.-.-.-.-.-.-.-."<<endl;
    cout<<"1. Gestionar Razas Alienigenas.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-..-"<<endl;
    cout<<"2. Gestionar Accesorios Ultra-Materiales-.-.-.-.-.-.-..-.-.-.-.-."<<endl;
    cout<<"3. Gestionar Estudiantes e Inventario (Mochilas)-.-.-.-.-.-.-..-."<<endl;
    cout<<"4. Gestionar Atmosferas de Combate (Ambientes)-.-.-.-.-.-.-..-.-."<<endl;
    cout<<"5. Consulta de Equipo (DISPONIBLE PRONTO)-.-.-.-.-.-.-..-.-.-.-.-"<<endl;
    cout<<"6. Batalla/Combate (DISPONIBLE PRONTO)-.-.-.-.-.-.-..-.-.-.-.-.-."<<endl;
    cout<<"7. Score/Tabla de competencias (DISPONIBLE PRONTO)-.-.-.-.-.-.-.."<<endl;
    cout<<"8. Salir del Juego-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cout<<"-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-"<<endl;
    cin>>mp;
    return mp;
}

main(){
    //(Parte Alien)
    string amb, esp;
    int hp,sp;
    //(Parte Accesorios)
    string nac;
    int hpp,spg,dr,hpr,spr,ox;
    //(Parte Soldados)
    string aluma,alumn;
    int cs,is,i;
    //recicla esp, amb, hp y sp de la parte alien
    //(Parte Ambiente)
    //recicla ox de la parte accesorios
    int mp, submal, submacr, submac, submsol, submap;
    //(Parte de Menus)
    //Aliens
    int wal1,wal2;
    //Ambiente
    int wame, wamb1;
    default_amb();
    default_alien();
    default_acceso();
    mp=menu_principal();
    switch(mp){
        case 1://Gestion de Especies
        submal=submenu_aliens();
        switch(submal){
            case 1:
            wal1=0;
            wal2=0;
            while(wal2<1){
                cout<<"Selecciona el planeta de tu nueva especie:"<<endl;
                cout<<"Tip: Recuerda escribir todo en MAYUSCULAS"<<endl;
                mos_amb();
                cin>>amb;
                    if(busc_amb(amb)==1){
                        cout<<"Dale nombre a la nueva raza espacial:"<<endl;
                        cin>>esp;
                        while(wal1<1){
                            cout<<"Indica su salud: (1-100)"<<endl;
                            cin>>hp;
                            cout<<"Indica su energia: (1-100)"<<endl;
                            cin>>sp;
                            if(valid_hsp(hp,sp)==1){
                                ins_alien(amb,esp, hp, sp);
                                cout<<"Su nueva especie fue registrada con exito"<<endl;
                                wal1=1;
                                wal2=1;
                                submenu_aliens();}
                            else{
                                cout<<"Uno o ambos valores ingresados, exceden el límite establecido"<<endl;
                                cout<<"Intente de nuevo..."<<endl;}
                        }
                    }
            
                    else{
                        cout<<"El ambiente seleccionado no existe o esta ingresado erroneamente"<<endl;
                        cout<<"Intente de nuevo..."<<endl;}
                }
            submenu_aliens();        
            break;

            case 2:
            cout<<"Selecciona la especie que deseas modificar:"<<endl;
            cout<<"Tip: Escribe el nombre EXACTAMENTE como aparece en la lista"<<endl;
            mos_alien();
            cin>>esp;
            mod_alien(esp);
            submenu_aliens();
            break;
            
            case 3:
            cout<<"Selecciona la especie que deseas eliminar:"<<endl;
            cout<<"Tip: Escribe el nombre EXACTAMENTE como aparece en la lista"<<endl;
            mos_alien();
            cin>>esp;
            elim_alien(esp);
            submenu_aliens();
            break;
            case 4:
            mos_alien();
            menu_principal();
            break;
            case 5:
            menu_principal();
            break;}
            
        break;

        case 2:
        submac=submenu_acceso();
        switch(submac){
            case 1:
            crea_acceso();
            submenu_acceso();
            break;

            case 2:
            cout<<"Escribe el nombre del accesorio que deseas modificar"<<endl;
            cin>>nac;
            mod_acceso(nac);
            submenu_acceso();
            break;
            
            case 3:
            cout<<"Escribe el nombre del accesorio que deseas eliminar"<<endl;
            cin>>nac;
            elim_acceso(nac);
            submenu_acceso();
            break;
            
            case 4:
            mos_acceso();
            break;
            
            case 5:
            menu_principal();
            break;}

        break;

        case 3:
        submsol=submenu_solds();
        switch(submsol){
            case 1:
            agg_solds();
            submenu_solds();
            break;

            case 2:
            cout<<"Ingresa el nombre del soldado que deseas modificar"<<endl;
            cin>>alumn;
            mod_solds(alumn);
            submenu_solds();
            break;
            
            case 3:
            cout<<"Ingresa el nombre del soldado que deseas eliminar"<<endl;
            cin>>alumn;
            elim_solds(alumn);
            submenu_solds();
            break;

            case 4:
            cout<<"Ingresa el nombre del soldado para llenar su mochila"<<endl;
            cin>>alumn;
            agg_mochila(alumn);
            submenu_solds();
            break;
            
            case 5:
            cout<<"Ingresa el nombre del soldado para modificar el contenido de su mochila"<<endl;
            cin>>alumn;
            mod_mochila(alumn);
            submenu_solds();
            break;

            case 6:
            cout<<"Ingresa el nombre del soldado para eliminar el contenido de su mochila"<<endl;
            cin>>alumn;
            elim_mochila(alumn);
            submenu_solds();
            break;

            case 7:
            menu_principal();
            break;}

        break;

        case 4:
        submap=submenu_amb();
        switch(submap){
            case 1:
            wamb1=0;
            while(wamb1<1){
                cout<<"Ingresa el nombre de tu ambiente"<<endl;
                cout<<"Tip: Escribe en Mayusculas"<<endl;
                cin>>amb;
                cout<<"Ingresa el nivel de oxigeno"<<endl;
                cout<<"Tip: Valores validos del (70-100)"<<endl;
                cin>>ox;
                if(valid_amb(amb)==1 && ox>70 && ox<100){
                    agg_amb(amb,ox);
                    cout<<"Su ambiente ha sido guardado con exito"<<endl;
                    wamb1=1;}
                else{
                    cout<<"Recuerda escribir el nombre de tu ambiente en Mayusculas"<<endl;
                    cout<<"Los valores validos para el oxigeno son del 70-100"<<endl;
                    cout<<"Intenta de nuevo..."<<endl;}
            }
            break;

            case 2:
            mod_amb();
            submenu_amb();
            break;

            case 3:
            while(wame<1){
                cout<<"Ingresa el nombre del ambiente que deseas eliminar"<<endl;
                cout<<"Tip: Recuerda escribirlo en mayusculas"<<endl;
                cin>>amb;
                if(valid_amb(amb)==1 && busc_amb(amb)==1){
                    elim_amb(amb);
                    wame=1;}
                else{
                    cout<<"Intenta de nuevo..."<<endl;}    
            submenu_amb();          
            }
            break;

            case 4:
            menu_principal();
            break;

        break;

        case 5:
        cout<<"FUNCION NO DISPONIBLE HASTA EL 30/06..."<<endl;
        menu_principal();
        break;

        case 6:
        cout<<"FUNCION NO DISPONIBLE HASTA EL 30/06..."<<endl;
        menu_principal();
        break;

        case 7:
        cout<<"FUNCION NO DISPONIBLE HASTA EL 30/06..."<<endl;
        menu_principal();
        break;

        case 8:
        exit(1);
        }
        system("pause"); 
        system("cls"); 
    }
}