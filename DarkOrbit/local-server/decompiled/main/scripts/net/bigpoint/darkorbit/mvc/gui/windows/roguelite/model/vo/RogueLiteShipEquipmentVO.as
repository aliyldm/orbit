package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo
{
   import net.bigpoint.darkorbit.com.module.InventoryItemModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RogueLiteShipEquipmentVO
   {
      
      public var lasersChanged:ISignal = new Signal();
      
      public var generatorsChanged:ISignal = new Signal();
      
      public var cpusChanged:ISignal = new Signal();
      
      private var _lasers:Vector.<ItemVO> = new Vector.<ItemVO>();
      
      private var _rocketLauncher:ItemVO;
      
      private var _generators:Vector.<ItemVO> = new Vector.<ItemVO>();
      
      private var _cpus:Vector.<ItemVO> = new Vector.<ItemVO>();
      
      public function RogueLiteShipEquipmentVO()
      {
         super();
      }
      
      public function get lasers() : Vector.<ItemVO>
      {
         return this._lasers;
      }
      
      public function get rocketLauncher() : ItemVO
      {
         return this._rocketLauncher;
      }
      
      public function get generators() : Vector.<ItemVO>
      {
         return this._generators;
      }
      
      public function get cpus() : Vector.<ItemVO>
      {
         return this._cpus;
      }
      
      public function addLaser(param1:String, param2:int) : void
      {
         var _loc3_:ItemVO = ItemDataProviderHelper.getItem(param1);
         if(!_loc3_.isLaser())
         {
            return;
         }
         _loc3_.upgradeLevel = param2;
         this._lasers.push(_loc3_);
         this.lasersChanged.dispatch(this._lasers);
      }
      
      public function clearLasers() : void
      {
         this._lasers = new Vector.<ItemVO>();
         this.lasersChanged.dispatch(this._lasers);
      }
      
      public function addRocketLauncher(param1:String) : void
      {
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(param1);
         this._rocketLauncher = _loc2_;
      }
      
      public function removeRocketLauncher() : void
      {
         this._rocketLauncher = null;
      }
      
      public function addGenerator(param1:String, param2:int) : void
      {
         var _loc3_:ItemVO = ItemDataProviderHelper.getItem(param1);
         if(!_loc3_.isShieldGenerator() && !_loc3_.isSpeedGenerator())
         {
            return;
         }
         _loc3_.upgradeLevel = param2;
         this._generators.push(_loc3_);
         this.generatorsChanged.dispatch(this._generators);
      }
      
      public function clearGenerators() : void
      {
         this._generators = new Vector.<ItemVO>();
         this.generatorsChanged.dispatch(this._generators);
      }
      
      public function addCpu(param1:String) : void
      {
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(param1);
         if(!_loc2_.isCPU())
         {
            return;
         }
         this._cpus.push(_loc2_);
         this.cpusChanged.dispatch(this._cpus);
      }
      
      public function clearCpus() : void
      {
         this._cpus = new Vector.<ItemVO>();
         this.cpusChanged.dispatch(this._cpus);
      }
      
      public function addItem(param1:InventoryItemModule) : void
      {
         var _loc2_:* = ItemVO.fromModule(param1);
         if(_loc2_.isLaser())
         {
            this._lasers.push(_loc2_);
         }
         else if(Boolean(_loc2_.isShieldGenerator()) || Boolean(_loc2_.isSpeedGenerator()))
         {
            this._generators.push(_loc2_);
         }
         else if(_loc2_.isCPU())
         {
            this._cpus.push(_loc2_);
         }
      }
   }
}

