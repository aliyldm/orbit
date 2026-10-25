package net.bigpoint.darkorbit.map.common.animation
{
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   
   public class AppendAnim implements IUpdatable
   {
      
      private var _target:Object;
      
      private var _props:Object = {};
      
      public function AppendAnim(param1:Object, param2:Object)
      {
         super();
         this._target = param1;
         this._props = param2;
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:String = null;
         if(this._target)
         {
            for(_loc2_ in this._props)
            {
               this._target[_loc2_] += Number(this._props[_loc2_]) * param1;
            }
         }
      }
   }
}

