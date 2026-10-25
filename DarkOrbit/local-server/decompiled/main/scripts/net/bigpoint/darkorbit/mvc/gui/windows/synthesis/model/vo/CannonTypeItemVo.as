package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo
{
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisCostLootCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisModuleCommand;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   
   public class CannonTypeItemVo
   {
      
      private var _config:ItemVO;
      
      private var _affectedShip:int = 0;
      
      private var _cost:Vector.<SynthesisCostLootCommand>;
      
      private var _cannon:Vector.<SynthesisCostLootCommand>;
      
      private var _items:Vector.<SynthesisCostLootCommand>;
      
      private var _startLevel:int = 0;
      
      private var _hasStartLevel:Boolean = false;
      
      private var _type:String;
      
      private var _lootId:String = "";
      
      public function CannonTypeItemVo(param1:String, param2:SynthesisModuleCommand)
      {
         super();
         this._type = param1;
         this._lootId = param2.lootId;
         this._affectedShip = param2.affectedShip;
         this._cost = param2.costs;
         this._hasStartLevel = SynthesisStartLevelUtil.hasMappedStartLevel(param2 as Object);
         this._startLevel = SynthesisStartLevelUtil.normalizeMappedStartLevel(param2 as Object);
         this._cannon = new Vector.<SynthesisCostLootCommand>();
         this._items = new Vector.<SynthesisCostLootCommand>();
         this.initData();
      }
      
      public function get startLevel() : int
      {
         return this._startLevel;
      }
      
      public function get hasStartLevel() : Boolean
      {
         return this._hasStartLevel;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get lootId() : String
      {
         return this._lootId;
      }
      
      public function get shipId() : int
      {
         return this._affectedShip;
      }
      
      public function get vo() : ItemVO
      {
         return this._config;
      }
      
      public function get costCannons() : Vector.<SynthesisCostLootCommand>
      {
         return this._cannon;
      }
      
      public function get costItems() : Vector.<SynthesisCostLootCommand>
      {
         return this._items;
      }
      
      private function initData() : void
      {
         var _loc2_:SynthesisCostLootCommand = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._cost.length)
         {
            _loc2_ = this._cost[_loc1_];
            if(_loc2_.certain)
            {
               this._cannon.push(_loc2_);
            }
            else
            {
               this._items.push(_loc2_);
            }
            _loc1_++;
         }
      }
   }
}

