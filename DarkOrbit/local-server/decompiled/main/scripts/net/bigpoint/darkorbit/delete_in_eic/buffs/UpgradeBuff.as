package net.bigpoint.darkorbit.delete_in_eic.buffs
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   
   public class UpgradeBuff
   {
      
      private var _currentBuff:ItemBuff;
      
      private var _targetBuff:ItemBuff;
      
      public function UpgradeBuff()
      {
         super();
      }
      
      public static function getBuffsByItemLevel(param1:ItemVO, param2:Number) : Vector.<UpgradeBuff>
      {
         var _loc8_:UpgradeBuff = null;
         var _loc3_:Vector.<ItemBuff> = ItemBuff.getBuffsByItemLevel(param1,param1.upgradeLevel);
         var _loc4_:Vector.<ItemBuff> = ItemBuff.getBuffsByItemLevel(param1,param2);
         var _loc5_:Vector.<UpgradeBuff> = new Vector.<UpgradeBuff>(0);
         var _loc6_:int = Math.max(_loc3_.length,_loc4_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = new UpgradeBuff();
            if(_loc3_.length > _loc7_)
            {
               _loc8_.currentBuff = _loc3_[_loc7_];
            }
            if(_loc4_.length > _loc7_)
            {
               _loc8_.targetBuff = _loc4_[_loc7_];
            }
            _loc5_.push(_loc8_);
            _loc7_++;
         }
         return _loc5_;
      }
      
      public function set currentBuff(param1:ItemBuff) : void
      {
         this._currentBuff = param1;
      }
      
      public function get currentBuff() : ItemBuff
      {
         return this._currentBuff;
      }
      
      public function set targetBuff(param1:ItemBuff) : void
      {
         this._targetBuff = param1;
      }
      
      public function get targetBuff() : ItemBuff
      {
         return this._targetBuff;
      }
   }
}

