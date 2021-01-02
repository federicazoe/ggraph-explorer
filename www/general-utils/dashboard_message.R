
make_dashboard_message_pre_data <- function() {
  
  HTML(
    "<h2>
      Welcome to <strong>ggraph explorer</strong>! 
      <i class='fab fa-wpexplorer'></i>
    </h2>
    
    <h3>
      This app will let you play around with some functions from the package 
      ggraph.
    </h3>
    <h3>
      We have downloaded from the web a dataset of 
      <a href = 'https://bigdata.duke.edu/projects/social-network-analysis-basics-case-studies-game-thrones-and-national-hockey-league'> Game of Thrones </a>,
      of 
      <a href = 'https://github.com/efekarakus/potter-network' > Harry Potter </a> 
      and of 
      <a href = 'https://rdrr.io/github/schochastics/networkdata/man/movie_439.html'> The Lord of the Rings </a>.
    
    </h3>
  
    "
  )
}


make_dashboard_message_post_data <- function(){
  
  HTML(
    "
    <h3>
     To get started with ggraph, click on the name of a dataset in the panel on 
     the left. Then, try to customize the <strong> layout </strong>,
     the <strong> nodes </strong> and the <strong> edges </strong> of the graph. 
     You can also take a look at the underlining 
     <strong> data tables </strong> of nodes and edges and at the <strong> code 
     </strong> used to produce your customized plot.
    </h3>
  
  <br>
  
  <h4>
  The code for this app is available on 
  <a href = 'https://github.com/federicazoe/ggraph-explorer'> GitHub</a>.
  </h4>
    
    
    
    <br>
    <br>
    <br>
    
    <div>
    <p> Credits:
      <ul>
        <li> Thomas Lin Pedersen is the author of the
          <a href = 'https://cran.r-project.org/web/packages/ggraph/index.html'>  
          ggraph</a> package </li>
        <li> This app and its name were inspired by 
          <a href = 'https://github.com/AlienDeg/shinyexplorer'> 
          ggplot explorer </a> </li>
      </ul>
    </div>
  
    "
  )
}


