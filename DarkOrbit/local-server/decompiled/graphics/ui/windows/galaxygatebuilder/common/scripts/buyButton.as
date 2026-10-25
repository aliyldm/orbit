package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol205")]
   public dynamic class buyButton extends MovieClip
   {
      
      public var mcHolder:MovieClip;
      
      public function buyButton()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

