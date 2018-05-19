let searchFields = document.querySelectorAll(".form-control");
let searchButtons = document.querySelectorAll(".tab-pane button");

if(searchFields != null && searchButtons != null) {
function filter(searchField) {
    let section = searchField.closest("section");
    
    if(section == null)
         return;
    let tr = section.querySelectorAll("tbody > tr");
        
    let search = new RegExp(searchField.value, 'i');

    for (let j = 0; j < tr.length; j++) {

        if (searchField.value != "") {
            if (search.test(tr[j].children[0].innerHTML + " " + tr[j].children[1].innerHTML))
                tr[j].style.display = "";
            else
                tr[j].style.display = "none";
        }
        else {
            tr[j].style.display = "";
        }
    }
}

for (let i = 0; i < searchFields.length; i++) {
    searchFields[i].addEventListener('keyup', function (e) {

        if (e.keyCode === 13) {
            filter(this);
        }
    });
}


for (let i = 0; i < searchButtons.length; i++) {
    searchButtons[i].addEventListener('click', function (e) {
        let searchField = this.closest(".input-group").children[1];
        filter(searchField);
    });
}
}