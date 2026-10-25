package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo
{
   public class LogLineInfoVO
   {
      
      public var text:String;
      
      public var hash:String;
      
      public var bgId:String;
      
      public var iconFrame:String;
      
      public var showMultiplier:Boolean;
      
      public function LogLineInfoVO(param1:String, param2:String, param3:String, param4:String, param5:Boolean = false)
      {
         super();
         this.text = param1;
         this.hash = param2;
         this.bgId = param3;
         this.iconFrame = param4;
         this.showMultiplier = param5;
      }
   }
}

