let select_coleccion = false;
  let select_molde = false;
  let numero_actual = '';
  let numero_anterior = '';
  let aux = 0;
/*---------------------------------------------------------------------------------------*/
/*                              COLECCIÓN Y MOLDE                                        */
/*---------------------------------------------------------------------------------------*/
//Coleccion
function Agregar_select_coleccion(datos){
  var select = document.getElementById("coleccion");
  select.innerHTML = "";

  var option = document.createElement("option"); // Declarar la variable option
    option.value = 'NaN';
    option.selected = true;
    option.disabled = true;
    option.textContent = 'Opciones';
    select.appendChild(option);

  for (var i = 0; i < datos.length; i++) {
    var opcion = document.createElement("option");
    opcion.text = datos[i].nombre;
    opcion.value = datos[i].linea + datos[i].uid_coleccion.toString();
    select.add(opcion);
  }
}

//Molde
function Agregar_select_Molde(datos){
  var select = document.getElementById("molde");
  select.innerHTML = "";
  var option = document.createElement("option"); // Declarar la variable option
  option.value = 'NaN';
  option.selected = true;
  option.disabled = true;
  option.textContent = 'Opciones';
  select.appendChild(option);

  for (var i = 0; i < datos.length; i++) {
    var opcion = document.createElement("option");
    opcion.text = datos[i].molde;
    opcion.value = datos[i].uid_molde;
    select.add(opcion);
  }  
}

document.addEventListener("DOMContentLoaded", function() {

  if(!select_coleccion) {
    select_coleccion = true;
    let peticion = {
      pet: 1
    };
    fetch('/Ceramica_Real/Pieza', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(peticion)
    })
      .then(response => response.json())
      .then(data => {
        let datos = data;
        console.log(datos);
        Agregar_select_coleccion(datos);
      })
      .catch(error => {
        console.error(error);
      });
  } else{
    select_coleccion = true;
  }

  if(!select_molde){
    select_molde= true;
    let peticion = {
      pet: 2
    };
    fetch('/Ceramica_Real/Pieza', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(peticion)
    })
      .then(response => response.json())
      .then(data => {
        let datos = data;
        Agregar_select_Molde(datos);
      })
      .catch(error => {
        console.error(error);
      });
  }else{
    select_molde= true;
  }
});


/*---------------------------------------------------------------------------------------*/
/*                                   Precio                                              */
/*---------------------------------------------------------------------------------------*/
function FORMATO_PRECIO(numero_actual){
  let contar = 0;
  let imprimir = '';
  while (contar < numero_actual.length){
    if(contar + 3 == numero_actual.length){
      imprimir = imprimir + numero_actual[contar] + '.';
    } else {
      imprimir = imprimir + numero_actual[contar];
    }
    contar++;
  }
  return imprimir;
}

document.addEventListener('DOMContentLoaded', function() {
  var input = document.getElementById('precio');
  input.addEventListener('input', function() {
    let aux2 = ['0','1','2','3','4','5','6','7','8','9'];    
    var numero_ingresado = input.value;
    if(aux2.includes(numero_ingresado[numero_ingresado.length - 1])){
      // Eliminar caracteres no numéricos
      numero_ingresado = input.value.replace(/\D/g, '');
      numero_actual = numero_actual.replace(/\D/g, '');
      numero_anterior = numero_anterior.replace(/\D/g, '');

      if( numero_ingresado.length < numero_anterior.length ){
        numero_anterior = numero_ingresado;
        numero_actual = numero_actual.slice(0, numero_ingresado.length);
        if(aux >= 1 || numero_actual.length <= 2){
          aux++
          switch(aux){
            case 1:
              numero_anterior = '0.' + numero_actual;
              input.value = numero_anterior;
            break;
            
            case 2:
              numero_actual = numero_actual[0]
              numero_anterior = '0.0' + numero_actual;
              input.value = numero_anterior;
            break;
            
            case 3:
              input.value = '';
              numero_actual = '';
              aux = 0;
            break;  
          }
        } else {
          numero_anterior = FORMATO_PRECIO(numero_actual);
          input.value = numero_anterior;
        }
      } else {
        if(aux >= 1){
          aux--;
        }
        if(input.value.length == 0 || (numero_actual.length == 0 && numero_ingresado == '0')){
          input.value = '';
          numero_actual = '';
        } else {
          numero_actual = numero_actual + numero_ingresado[numero_ingresado.length - 1];
          // Formatear el número según el estándar monetario
          if (numero_actual.length == 1 ) {
            numero_anterior = '0.0' + numero_ingresado; 
          } else if(numero_actual.length == 2){
            numero_anterior = '0.' + numero_actual;
          } else {
            numero_anterior = FORMATO_PRECIO(numero_actual);
          }
          input.value = numero_anterior;
        }
      }
      console.log(numero_actual + ' '+ numero_actual.length)

    } else {
      aux++;
      if( aux == 1 || numero_actual.length == 0){
        input.value = '';
      } else if( aux == 2 ||numero_actual.length >= 1){
        input.value = numero_anterior;
        aux--;
      }
    }
  });
});

/*---------------------------------------------------------------------------------------*/
/*                                   Agregar                                             */
/*---------------------------------------------------------------------------------------*/

const agregar = document.getElementById("agregar");
agregar.addEventListener("click", function(event) {
  var coleccion=document.getElementById("coleccion").value;
  var molde=document.getElementById("molde").value;
  var precio=document.getElementById("precio").value;
  var descripcion=document.getElementById("descripcion").value;

  if(coleccion == 'NaN'){
    alert(' Error 1: Debe elegir una colección.');
  } else if(molde == 'NaN'){
    alert('Error 2: Debe elegir un molde.');
  } else if(precio.length == 0 && false){

  } else if(! descripcion == null){

  }else {
    let des = descripcion;
    if(descripcion.length == 0){
      des = null;
    }

    if(coleccion[0] == 'F'){
      let peticion = {
        pet: 3,
        coleccion: coleccion.slice(1, coleccion.length), 
        descripcion: des, 
        precio: precio, 
        molde: molde
      };
    }else {
      let peticion = {
        pet: 3,
        coleccion: coleccion.slice(1, coleccion.length), 
        descripcion: des, 
        precio: null, 
        molde: molde
      };
    }
  }
});


