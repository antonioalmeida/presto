let searchBar = document.getElementById('nav-search-bar');
let searchBtn = document.getElementById('nav-search-btn');
let counter = 0;

searchBtn.addEventListener('click', function(){
    searchBar.classList.toggle('open');

    if(searchBar.classList.contains('open'))
      searchBar.focus();
    else {
      if(searchBar.value !== "")
        searchBtn.href = "search.html";
      else
        searchBar.blur();
    }
});
