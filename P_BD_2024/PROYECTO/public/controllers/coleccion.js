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

  if(linea == 'NaN' && nueva_linea.length == 0){
    alert(' Error 1: Debe elegir una linea.');
  }else if(nueva_linea.length != 0 && linea != 'NaN'){
    aux = nueva_linea;
  }else if(categoria == 'NaN' && nueva_categoria.length == 0){
    alert('Error 2: Debe elegir una categoria.');
  } else if(categoria == 'NaN' && nueva_categoria != 0){
    aux2 = nueva_categoria;
  }else if(nombre.length == 0){
    alert('Vacio');
  }else if( nombre.length > 40){
    alert('Mamon1');
  }else if(descripcion.length == 0){
    alert('Error 3: Descripción no puede quedar vacia.');
  }else if(descripcion.length > 512){
    alert('Mamon');
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
        })
        .catch(error => {
          console.error(error);
        });
  }  
});