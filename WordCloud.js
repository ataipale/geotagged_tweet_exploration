var width = 800,
    height = 300;

var color = d3.scale.linear()
            .domain([0,1,2,3,4,5,6,10,15,20,100])
            .range(["#ddd", "#ccc", "#bbb", "#aaa", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

d3.json('wordCloud.json', function(error, data) {

    console.log(data);

    d3.layout.cloud().size([width, height])
            .words(data)
            .rotate(0)
            .fontSize(function(d) { return d.size; })
            .on('end', draw)
            .start();

    function draw(words) {
        d3.select("body").append("svg")
                .attr("width", 800)
                .attr("height", 350)
                .attr("class", "wordcloud")
                .append("g")
                // without the transform, words words would get cutoff to the left and top, they would
                // appear outside of the SVG area
                .attr("transform", "translate(320,200)")
                .selectAll("text")
                .data(words)
                .enter().append("text")
                .style("font-size", function(d) { return d.size + "px"; })
                .style("fill", function(d, i) { return color(i); })
                .attr("transform", function(d) {    
                    return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
                })
                .text(function(d) { return d.text; });
            }
})