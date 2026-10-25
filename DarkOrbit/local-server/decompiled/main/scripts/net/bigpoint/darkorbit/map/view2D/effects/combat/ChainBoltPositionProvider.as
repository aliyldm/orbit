package net.bigpoint.darkorbit.map.view2D.effects.combat
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   
   public class ChainBoltPositionProvider
   {
      
      private var _chainArray:Array;
      
      private var _positions:Vector.<BindablePointLite> = new Vector.<BindablePointLite>();
      
      private var _attacker:MapEntity;
      
      private var _attackerId:int;
      
      private var _attackerPosition:PointLite;
      
      public function ChainBoltPositionProvider(param1:Array, param2:MapEntity)
      {
         super();
         this._attacker = param2;
         this._chainArray = param1;
         this.initPositions();
      }
      
      private function initPositions() : void
      {
         var _loc3_:MapEntity = null;
         var _loc1_:int = int(this._chainArray.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = ScreenManager.getInstance().map.getEntityById(this._chainArray[_loc2_]);
            if(_loc3_)
            {
               this._positions.push(_loc3_.position);
            }
            _loc2_++;
         }
         this._attackerPosition = this._attacker ? this._attacker.position : new PointLite();
      }
      
      public function get positions() : Vector.<BindablePointLite>
      {
         return this._positions;
      }
      
      public function get attackerId() : int
      {
         return this._attackerId;
      }
      
      public function get attackerPosition() : PointLite
      {
         return this._attackerPosition;
      }
   }
}

