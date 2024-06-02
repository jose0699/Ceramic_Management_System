  let select_coleccion = false;
  let select_molde = false;

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
    opcion.value = datos[i].uid_molde;
    select.add(opcion);
  }
}

//Molde
function Agregar_select_coleccion(datos){
  var select = document.getElementById("molde");
  select.innerHTML = "";

  var option = document.createElement("option"); // Declarar la variable option
    option.value = 'NaN';
    option.selected = true;
    option.disabled = true;
    option.textContent = 'Opciones';
    select.appendChild(option);

  /*  Esta parte se esta decidiendo
  for (var i = 0; i < datos.length; i++) {
    var opcion = document.createElement("option");
    opcion.text = datos[i].nombre;
    opcion.value = datos[i].uid_molde;
    select.add(opcion);
  }*/
}

document.addEventListener("DOMContentLoaded", function() {

  if(!select_coleccion) {
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
        Agregar_select_coleccion(datos);
      })
      .catch(error => {
        console.error(error);
      });   
  } else{
    select_coleccion = true;
  }

  if(!select_molde){

  }else{

  }
});

/*---------------------------------------------------------------------------------------*/
/*                                   Agregar                                             */
/*---------------------------------------------------------------------------------------*/

const agregar = document.getElementById("agregar");
agregar.addEventListener("click", function(event) {
  alert('En proceso guapo');
});

/*---------------------------------------------------------------------------------------*/
/*                                   Precio                                              */
/*---------------------------------------------------------------------------------------*/

document.addEventListener('DOMContentLoaded', function() {
  var input = document.getElementById('precio');

  input.addEventListener('input', function() {
    // Eliminar caracteres no numéricos
    var numero = input.value.replace(/\D/g, '');

    // Formatear el número según el estándar monetario
    if (numero.length > 0) {
      var parteEntera = numero.slice(0, -2) || '0';
      var parteDecimal = numero.slice(-2);

      input.value = `${parteEntera}.${parteDecimal}`;
    } else {
      input.value = '';
    }
  });
});


