package net.bigpoint.darkorbit.map.model.ship.patterns
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class ExpansionPattern extends ResourcePattern
   {
      
      private var _salvos:Vector.<Vector.<String>>;
      
      private var _cannons:Object = {};
      
      public function ExpansionPattern(param1:String, param2:Vector.<Vector.<String>>, param3:Object)
      {
         super(0,param1);
         this._salvos = param2;
         this._cannons = param3;
      }
      
      public function get salvos() : Vector.<Vector.<String>>
      {
         return this._salvos;
      }
      
      public function get cannons() : Object
      {
         return this._cannons;
      }
      
      override public function getPatternID() : int
      {
         return super.getPatternID();
      }
   }
}

