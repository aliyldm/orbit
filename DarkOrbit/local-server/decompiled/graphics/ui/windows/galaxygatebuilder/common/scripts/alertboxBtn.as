package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol288")]
   public dynamic class alertboxBtn extends MovieClip
   {
      
      public var txtLabel:TextField;
      
      public function alertboxBtn()
      {
         super();
         addFrameScript(11,this.frame12);
      }
      
      internal function frame12() : *
      {
         gotoAndPlay("hover");
      }
   }
}

