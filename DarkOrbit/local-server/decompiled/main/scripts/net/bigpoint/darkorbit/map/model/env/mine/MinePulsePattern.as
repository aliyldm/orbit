package net.bigpoint.darkorbit.map.model.env.mine
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class MinePulsePattern extends ResourcePattern
   {
      
      public var color:uint;
      
      public var alpha:Number;
      
      public var scale:Number;
      
      private var _resKey3D:String;
      
      public function MinePulsePattern(param1:int, param2:String, param3:uint, param4:Number, param5:Number, param6:String)
      {
         super(param1,param2);
         this.color = param3;
         this.alpha = param4;
         this.scale = param5;
         this._resKey3D = param6;
      }
      
      public function get resKey3D() : String
      {
         return this._resKey3D;
      }
   }
}

