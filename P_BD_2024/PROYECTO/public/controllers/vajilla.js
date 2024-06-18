  let select_coleccion = false;


//Lista en memoria para testear
let piezasColeccion = [/*{
  id: '1035149785',
  nombre: 'Amazonia Taza Moca',
  precio: null
},{
  id: '1035140455',
  nombre: 'Amazonia Tetera 6pers',
  precio: null
},{
  id: '1035140004',
  nombre: 'Amazonia Lechera 6pers',
  precio: null
}*/
];

//Aquí se irán guardando el id de la pieza y la cantidad de que tiene la vajilla de esta misma 
let piezasVajilla = [];

//se genera el html de la coleccion, en un futuro se llamará a esta función cada vez que se seleccione una función en el select
//renderListaColeccion();

//FUNCIONES DE GENERACION DE HTML
//renderiza la lista de la coleccion

function renderListaColeccion(){
  let listaPiezasHTML = '';

  piezasColeccion.forEach((pieza) => {
    const {id, nombre,precio} = pieza;

    let html = `
      <div class = "pieza-container js-pieza-container" data-pieza-id="${id}">
          ${nombre}

          <div>
              <div style="color: rgb(214, 91, 42); display: inline">$${precio}</div>
              <button class="add-button js-add-button" data-pieza-id="${id}">+</button>
              <button class="minus-button js-minus-button" data-pieza-id="${id}">-</button>
          </div>
      </div>
    `;

    listaPiezasHTML += html;
  });

  document.querySelector('.js-coleccion-scrollmenu')
    .innerHTML = listaPiezasHTML;

  //Se añaden los controladores a los botones de + y -
  document.querySelectorAll('.js-add-button')
    .forEach((addButton) =>{
      addButton.addEventListener('click', () =>{
        const {piezaId} = addButton.dataset;
        addPieza(piezaId);
      });
    })


  document.querySelectorAll('.js-minus-button')
    .forEach((minusButton) =>{
      minusButton.addEventListener('click', () =>{
        const {piezaId} = minusButton.dataset;
        minusPieza(piezaId);
      });
    })

}

//renderiza la lista de la vajilla
function renderListaVajilla() {
  let resumenVajillaHTML = '';
  let precioVajilla = 0;

  piezasVajilla.forEach((pieza) => {
    const id = pieza.id;

    const piezaEncontrada = getPieza(id);

    const html = `
      <div class="pieza-container">
        ${piezaEncontrada.nombre}
        <p class="js-quantity">${pieza.cantidad}</p>
      </div>
    `;

    resumenVajillaHTML += html;

    // Limitar el precio a dos decimales
    const piecePriceWithTwoDecimals = (piezaEncontrada.precio * pieza.cantidad).toFixed(2);
    precioVajilla += parseFloat(piecePriceWithTwoDecimals);
  });

  // Aplicar el descuento del 15%
  const precioDescuento = precioVajilla - (precioVajilla * 0.15);

  // Limitar el precio total a dos decimales
  const totalPriceWithTwoDecimals = precioDescuento.toFixed(2);

  document.querySelector('.js-vajilla-scrollmenu')
    .innerHTML = resumenVajillaHTML;

  document.querySelector('.js-price-tag')
    .innerHTML = `PRECIO ESTIMADO: $${totalPriceWithTwoDecimals}`;
}

//FUNCIONES DE BUSQUEDA EN PIEZASCOLECCION Y AÑADIR A LA LISTA DE LA VAJILLA
function addPieza(id){
  let piezaBuscada;

  piezasVajilla.forEach((pieza) =>{
    if(id === pieza.id){
      piezaBuscada = pieza;
    }
  });

  if(piezaBuscada){
    piezaBuscada.cantidad++;
  }else{
    piezasVajilla.push({
      id: id,
      cantidad: 1,
    })
  }

  renderListaVajilla();
}

function minusPieza(id){
  let piezaBuscada;
  let indexPieza;

  piezasVajilla.forEach((pieza,index) =>{
    if(id === pieza.id){
      piezaBuscada = pieza;
      indexPieza = index;
      piezaBuscada.cantidad--;
    }
  });


  if(!piezaBuscada.cantidad){
    piezasVajilla.splice(indexPieza,1);
  }

  renderListaVajilla();
}

function getPieza(id){
  let piezaBuscada;

  piezasColeccion.forEach((pieza) =>{
    if(id === pieza.id){
      piezaBuscada = pieza;
    }
  });

  return piezaBuscada;
};

/*---------------------------------------------------------------------------------------*/
/*                                     COLECCIÓN                                         */
/*---------------------------------------------------------------------------------------*/

//Molde
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
    opcion.value = datos[i].uid_coleccion.toString();
    select.add(opcion);
  }
}

document.addEventListener("DOMContentLoaded", function() {
  if(!select_coleccion) {
    select_coleccion = true;
    let peticion = {
      pet: 1
    };
    fetch('/Ceramica_Real/Vajilla', {
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
});

function LLENAR_PIEZA_COLECCION(datos){
  for (i=0; i<datos.length; i++){

  }
}

const coleccion = document.getElementById("coleccion");
coleccion.addEventListener("change", function(event) {
  
  if(coleccion.value != 'NaN'){
    let peticion = {
      pet: 2,
      coleccion: parseInt(coleccion.value) 
    };
    fetch('/Ceramica_Real/Vajilla', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(peticion)
    })
      .then(response => response.json())
      .then(data => {
        let datos = data;
        let aux = datos[0].linea === 'F' ? 3 : 4;
        let peticion_dos = {
          pet: aux,
          coleccion: parseInt(coleccion.value) 
        };
       
        //Segunda consulta
        fetch('/Ceramica_Real/Vajilla', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(peticion_dos)
        })
          .then(response => response.json())
          .then(data_dos => {
            piezasColeccion = [];
            renderListaColeccion();
            piezasVajilla = [];
            renderListaVajilla()
            data_dos.forEach(pieza => {
              let piezaObj = {
                id: pieza.id,
                nombre: pieza.nombre,
                precio: pieza.precio
              };
              piezasColeccion.push(piezaObj);
            });
            renderListaColeccion();
          })
          .catch(error => {
            console.error(error);
          });
      })
      .catch(error => {
        console.error(error);
      });
  }
});

/*---------------------------------------------------------------------------------------*/
/*                                     AGREGAR                                           */
/*---------------------------------------------------------------------------------------*/
function limpieza() {
  const elements = ['coleccion', 'capacidad', 'nombre', 'descripcion'];
  elements.forEach(element => {
    document.getElementById(element).value = element === 'coleccion' || element === 'capacidad' ? 'NaN' : '' ;
  });
  piezasColeccion = [];
  piezasVajilla = [];
  renderListaColeccion();
  renderListaVajilla()
}

let pieza_cantidad= [];
const agregar = document.getElementById("agregar");
agregar.addEventListener("click", function(event) {
  let nombre = document.getElementById("nombre");
  let capacidad = document.getElementById("capacidad");
  let descripcion = document.getElementById("descripcion");
  let coleccion = document.getElementById("coleccion");
  let aux = descripcion.value;

  if (coleccion.value ==='NaN') {
    alert('Error: Debe seleccionar una colección válida.');
  } else if (piezasVajilla.length == 0 || piezasVajilla.length === null) {
    alert('Error: Debe seleccionar al menos una pieza de vajilla.');
  } else if (nombre.length == 0) {
    alert('Error: Debe ingresar un nombre.');
  } else if (nombre.length > 60) {
    alert('Error: El nombre no debe exceder los 60 caracteres.');
  } else if (capacidad.value == 'NaN') {
    alert('Error: Debe seleccionar una capacidad válida.');
  } else if (parseInt(capacidad.value) > 9) {
    alert('Error: La capacidad no debe exceder 9.');
  } else if (descripcion.length == 0) {
    aux = null;
  } else if (descripcion.length > 256) {
    alert('Error: La descripción no debe exceder los 256 caracteres.');
  }else {
    let peticion = {
      pet: 5,
      nombre: nombre.value,
      capacidad: capacidad.value,
      descripcion: aux
    };
    fetch('/Ceramica_Real/Vajilla', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(peticion)
    })
    .then(response => response.json())
    .then(data => {
      const peticion_dos = {
        pet: 6,
        vajilla: parseInt(data[0].insertar_vajilla),
        coleccion: parseInt(coleccion.value),
        pieza_cantidad: piezasVajilla
      };
    
      return fetch('/Ceramica_Real/Vajilla', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(peticion_dos)
      });
    })
    .then(response => response.json())
    .then(data_dos => {
      alert('Insertado con éxito');
      limpieza()
    })
    .catch(error => {
      console.error(error);
    });
  }
});
