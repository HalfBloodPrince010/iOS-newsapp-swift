const express = require('express');
const axios = require('axios');
const cors = require('cors')
const fs = require('fs')
const googleTrends = require('google-trends-api');


// Creating an application

const app = express();

const PORT = process.env.PORT  || 5000 ;
// Creating route handlers..
app.use(cors())


app.get('/headlines', function(req, res){
  console.log("Headlines ..")
  url = 'https://content.guardianapis.com/search?order-by=newest&show-fields=starRating,headline,thumbnail,short-url&api-key=[GUARDIAN-API-KEY]'
  axios.get(url)
    .then(function (responseData) {
      let data = responseData.data.response.results
      let newsArray = data.map(news=>{
        if(news.hasOwnProperty('id') && news.hasOwnProperty('sectionName') && news.hasOwnProperty('webPublicationDate') && news.hasOwnProperty('webTitle') && news.hasOwnProperty('fields')){
        let image = (!news.fields.thumbnail)?"No":news.fields.thumbnail
        let title = news.webTitle
        let section = "|" + news.sectionName
        let id = news.id
        // Bookmark date
        let date_full = news.webPublicationDate.slice(0,10).split("-")
        let ba_date = parseInt(date_full[1])
        let month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        let month = month_names[ba_date-1]
        let bdate = date_full[2] + " " + month
        // News Date
        let a_date = news.webPublicationDate
        let date = Date.parse(news.webPublicationDate)
        // Current Date
        var current_date = Date.parse(new Date());
        // Difference
        var secs = Math.floor((current_date - date)/1000);
        var mins = Math.floor(secs/60);
        var hrs = Math.floor(mins/60);
        var days = Math.floor(hrs/24);
        hrs = hrs-(days*24);
        mins = mins-(days*24*60)-(hrs*60);
        secs = secs-(days*24*60*60)-(hrs*60*60)-(mins*60);
        let difference = ""
        if(hrs != 0){
          difference =  hrs + "h"
        }
        else if(mins != 0){
          difference = mins + "m"
        }
        else{
          difference = secs + "s"
        }

        difference = difference

        // return difference

        let json_string = '{"image":"' +  image + '","title":"' + title + '","section":"' + section + '","id":"' + id + '","bdate":"' + bdate +'","duration":"' + difference + '"}'

        let data = JSON.parse(json_string)

        return data

        }
      })
      res.send(newsArray);
    })
    .catch(function (error) {
      console.log(error);
    })
  });


app.get('/guardian/:search', function(req, res){
  let section = req.params.search;
  let url = 'http://content.guardianapis.com/' + section + '?api-key=[GUARDIAN-API-KEY]&show-blocks=all';
  axios.get(url)
    .then(function (responseData) {
      let data = responseData.data.response.results
      let newsArray = data.map(news=>{
        if(news.hasOwnProperty('id') && news.hasOwnProperty('sectionName') && news.hasOwnProperty('webPublicationDate') && news.hasOwnProperty('webTitle') && news.blocks.hasOwnProperty('main')){
        let image = ""
        if(news.blocks.main.elements[0].assets.length == 0){
          image = "No"
        }
        else{
          image =  news.blocks.main.elements[0].assets[0].file
        }
        let title = news.webTitle
        let section = "|" + news.sectionName
        let id = news.id
         // Bookmark date
        let date_full = news.webPublicationDate.slice(0,10).split("-")
        let ba_date = parseInt(date_full[1])
        let month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        let month = month_names[ba_date-1]
        let bdate = date_full[2] + " " + month
        // News Date
        let a_date = news.webPublicationDate
        let date = Date.parse(news.webPublicationDate)
        // Current Date
        var current_date = Date.parse(new Date());
        // Difference
        var secs = Math.floor((current_date - date)/1000);
        var mins = Math.floor(secs/60);
        var hrs = Math.floor(mins/60);
        var days = Math.floor(hrs/24);
        hrs = hrs-(days*24);
        mins = mins-(days*24*60)-(hrs*60);
        secs = secs-(days*24*60*60)-(hrs*60*60)-(mins*60);
        let difference = ""
        if(hrs != 0){
          difference =  hrs + "h"
        }
        else if(mins != 0){
          difference = mins + "m"
        }
        else{
          difference = secs + "s"
        }

        difference = difference

        // return difference

        let json_string = '{"image":"' +  image + '","title":"' + title + '","section":"' + section + '","id":"' + id + '","bdate":"'+ bdate +'","duration":"' + difference + '"}'

        let data = JSON.parse(json_string)

        return data

        }
      })
      newsArray = newsArray.filter(news => {
        if(news){
          return true
        }
      })
      console.log(newsArray)
      res.send(newsArray);
    })
    .catch(function (error) {
      console.log(error);
    })
  });

app.get(/^\/article\/(.*)/, function(req, res){
    let x = req.originalUrl
    let article_id = x.slice(9)
    console.log("Article ID Node",article_id)
    let url = 'https://content.guardianapis.com/' + article_id + '?api-key=[GUARDIAN-API-KEY]&show-blocks=all';
    axios.get(url)
      .then(function (responseData) {
        let news = responseData.data.response.content
        let data
          if(news.hasOwnProperty('id') && news.hasOwnProperty('sectionName') && news.hasOwnProperty('webPublicationDate') && news.hasOwnProperty('webTitle') && news.blocks.hasOwnProperty('main')){
            // Detailed Article
            // Image
            let image = ""
            if(news.blocks.main.elements[0].assets.length == 0){
              image = "No"
            }
            else{
              image =  news.blocks.main.elements[0].assets[news.blocks.main.elements[0].assets.length-1].file
            }
            // Other details
            let title = news.webTitle
            let weburl = news.webUrl
            let section = news.sectionName
            // News Date
            let date_full = news.webPublicationDate.slice(0,10).split("-")
            let a_date = parseInt(date_full[1])
            let month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            let month = month_names[a_date-1]
            let date = date_full[2] + " " + month + " " +date_full[0]
            let bdate = date_full[2] + " " + month
            console.log(date)
            // Description
            let description_array = news.blocks.body
            var content = ""
            description_array.forEach(body =>{
              content += body.bodyHtml
            })
            responseData.data.response.content["date"] = date
            responseData.data.response.content["title"] = title
            responseData.data.response.content["weburl"] = weburl
            responseData.data.response.content["section"] = section
            responseData.data.response.content["content"] = content
            responseData.data.response.content["image"] = image
            responseData.data.response.content["bdate"] = bdate

          }
        res.send(responseData.data.response.content);
        // res.send(content);
      })
      .catch(function (error) {
        console.log(error);
      })
    });

app.get('/searchresults/:qword', function(req, res){
    let word = req.params.qword;
    let url = 'https://content.guardianapis.com/search?q=' + word + '&api-key=[GUARDIAN-API-KEY]&show-blocks=all';
      axios.get(url)
        .then(function (responseData) {
          let data = responseData.data.response.results
          let newsArray = data.map(news=>{
            if(news.hasOwnProperty('id') && news.hasOwnProperty('sectionName') && news.hasOwnProperty('webPublicationDate') && news.hasOwnProperty('webTitle') && news.blocks.hasOwnProperty('main')){
            let image = ""
            if(news.blocks.main.elements[0].assets.length == 0){
              image = "No"
            }
            else{
              image =  news.blocks.main.elements[0].assets[0].file
            }
            let title = news.webTitle
            let section = "|" + news.sectionName
            let id = news.id
            // Bookmark date
            let date_full = news.webPublicationDate.slice(0,10).split("-")
            let ba_date = parseInt(date_full[1])
            let month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            let month = month_names[ba_date-1]
            let bdate = date_full[2] + " " + month
            // News Date
            let a_date = news.webPublicationDate
            let date = Date.parse(news.webPublicationDate)
            // Current Date
            var current_date = Date.parse(new Date());
            // Difference
            var secs = Math.floor((current_date - date)/1000);
            var mins = Math.floor(secs/60);
            var hrs = Math.floor(mins/60);
            var days = Math.floor(hrs/24);
            hrs = hrs-(days*24);
            mins = mins-(days*24*60)-(hrs*60);
            secs = secs-(days*24*60*60)-(hrs*60*60)-(mins*60);
            let difference = ""
            console.log("days",days, hrs, mins)
            if (days != 0){
              difference = days + "d"
            }
            else if(hrs != 0){
              difference =  hrs + "h"
            }
            else if(mins != 0){
              difference = mins + "m"
            }
            else{
              difference = secs + "s"
            }
    
            difference = difference
    
            // return difference
    
            let json_string = '{"image":"' +  image + '","title":"' + title + '","section":"' + section + '","bdate":"' + bdate +'","id":"' + id + '","duration":"' + difference + '"}'
    
            let data = JSON.parse(json_string)
    
            return data
    
            }
          })
          newsArray = newsArray.filter(news => {
            if(news){
              return true
            }
          })
          console.log(newsArray)
          res.send(newsArray);

        })
        .catch(function (error) {
          console.log(error);
      })
    });

app.get('/googletrends/:search', function(req, res){
    let section = req.params.search;
    let startDate = new Date(2019, 06, 01)
    googleTrends.interestOverTime({keyword: section, startTime: startDate})
    // let data_to_send = {}
    .then(function(results){
      console.log(results);
      let raw_data = JSON.parse(results)
      let data = raw_data.default.timelineData
      let values = data.map(value => {
        return value.value[0]
      })
      console.log(values.length)
      raw_data["values"] = values
      res.send(raw_data);
      })
    .catch(function(err){
      console.error(err);
      });
    });


app.listen(PORT, ()=>console.log(`Server started on port ${PORT}`))