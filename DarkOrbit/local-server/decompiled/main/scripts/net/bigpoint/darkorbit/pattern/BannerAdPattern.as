package net.bigpoint.darkorbit.pattern
{
   public class BannerAdPattern
   {
      
      public var id:int;
      
      public var price:Number = -1;
      
      public var baseKey:String;
      
      public var paymentKey:String;
      
      public var footerKey:String;
      
      public var windowID:String;
      
      public var url:String;
      
      public var jsFunctionName:String;
      
      public var showWindowTitle:Boolean;
      
      public function BannerAdPattern(param1:int, param2:String, param3:String, param4:String = null, param5:String = null, param6:Boolean = true)
      {
         super();
         this.id = param1;
         this.windowID = "banner" + param1;
         this.baseKey = param2;
         this.paymentKey = param3;
         this.url = param4;
         this.jsFunctionName = param5;
         this.showWindowTitle = param6;
      }
   }
}

