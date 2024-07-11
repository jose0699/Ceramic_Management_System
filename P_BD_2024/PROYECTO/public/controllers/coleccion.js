function limpieza() {
  const elements = ['linea', 'categoria', 'nueva_linea', 'nueva_categoria', 'nombre','descripcion'];
  elements.forEach(element => {
    document.getElementById(element).value = element === 'linea' || element === 'categoria' ? 'NaN' : '' ;
  });
  numero_actual = '';
  numero_anterior = '';
}

const agregar = document.getElementById("agregar");
agregar.addEventListener("click", function(event) {
  var linea=document.getElementById("linea").value;
  var categoria=document.getElementById("categoria").value;
  var nueva_linea=document.getElementById("nueva_linea").value;
  var nueva_categoria=document.getElementById("nueva_categoria").value;
  var nombre=document.getElementById("nombre").value;
  var descripcion=document.getElementById("descripcion").value;
  let aux = linea;
  let aux2 = categoria;

  if (linea === 'NaN' && nueva_linea.length === 0) {
    alert('Error: Debe seleccionar una línea o ingresar una nueva línea.');
  } else if (nueva_linea.length !== 0 && linea !== 'NaN') {
    aux = nueva_linea;
  } else if (categoria === 'NaN' && nueva_categoria.length === 0) {
    alert('Error: Debe seleccionar una categoría o ingresar una nueva categoría.');
  } else if (categoria === 'NaN' && nueva_categoria !== 0) {
    aux2 = nueva_categoria;
  } else if (nombre.length === 0) {
    alert('Error: Debe ingresar un nombre.');
  } else if (nombre.length > 40) {
    alert('Error: El nombre no debe exceder los 40 caracteres.');
  } else if (descripcion.length === 0) {
    alert('Error: Debe ingresar una descripción.');
  } else if (descripcion.length > 512) {
    alert('Error: La descripción no debe exceder los 512 caracteres.');
  } else{
    let peticion = {
      pet: 1,
      nombre: nombre,
      linea: aux, 
      categoria:aux2,
      descripcion: descripcion,
    }
    fetch('/Ceramica_Real/Coleccion', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
        body: JSON.stringify(peticion)
      })
      .then(response => response.json())
      .then(data => {
        alert('Insertado con exito');
        limpieza();
      })
      .catch(error => {
        console.error(error);
      });
  }  
});