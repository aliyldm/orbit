package net.bigpoint.darkorbit.pattern
{
   public class EffectPattern
   {
      
      public var id:int;
      
      public var resKey:String;
      
      public var radius:int;
      
      public var scale:Number = 1;
      
      public var isChargeShotPlus:Boolean = false;
      
      public var isLoop:Boolean = true;
      
      public var initAlpha:Number = 0;
      
      public var FPS:int = 25;
      
      public var isDAEffect:Boolean = false;
      
      public var runScale:Number = 1;
      
      public var scale2D:Number = 1;
      
      public var soundId:Number = -1;
      
      public function EffectPattern(param1:int, param2:String, param3:int = -1, param4:Number = 1, param5:Number = 1, param6:Number = -1)
      {
         super();
         this.radius = param3;
         this.id = param1;
         this.resKey = param2;
         this.scale = param4;
         this.scale2D = param5;
         this.soundId = param6;
      }
   }
}

