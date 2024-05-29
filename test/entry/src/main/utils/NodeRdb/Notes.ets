export class Note{
  id:number
  title:string;
  text:string;
  time:string;


  constructor(title,text, time) {
    this.title = title;
    this.text = text;
    this.time = time;
  }

  setID(id:number){
    this.id = id;
  }

  setTitle(title:string){
    this.title = title;
  }

  setText(text:string){
    this.text = text;
  }

  toString(){
    return this.id+' '+this.title+ ' ' + this.text+ ' ' + this.time;
  }
}