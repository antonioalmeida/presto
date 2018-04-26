let searchBar = document.getElementById('nav-search-bar');
let searchBtn = document.getElementById('nav-search-btn');
let counter = 0;

if(searchBtn != null)
  searchBtn.addEventListener('click', addSearchHandler);

function addSearchHandler(){
    searchBar.classList.toggle('open');

    if(searchBar.classList.contains('open'))
      searchBar.focus();
    else {
      if(searchBar.value !== "")
        searchBtn.href = "search.html";
      else
        searchBar.blur();
    }
}
