package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.components
{
   import com.greensock.TweenMax;
   import flash.events.MouseEvent;
   import mx.collections.ArrayList;
   import mx.core.IUIComponent;
   import mx.events.DragEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.DragManager;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.ModuleVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItem;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItemBase;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.events.BattleStationWindowEvent;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   public class ModuleInstallationViewBase extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1791483012titleLabel:Label;
      
      private var _1826203522leftInner1:ModuleHolster;
      
      private var _702536233rightInner1:ModuleHolster;
      
      private var _2004621821leftOuter1:ModuleHolster;
      
      private var _524117934rightOuter1:ModuleHolster;
      
      private var _103669hub:ModuleHolster;
      
      private var _2004621822leftOuter2:ModuleHolster;
      
      private var _524117933rightOuter2:ModuleHolster;
      
      private var _1826203523leftInner2:ModuleHolster;
      
      private var _702536232rightInner2:ModuleHolster;
      
      protected var _860014364xOffsetInnerModules:int = 27;
      
      protected var _761672023xOffsetOuterModules:int = 78;
      
      protected var _15542493yOffsetInnerModules:int = 67;
      
      protected var _82799848yOffsetOuterModules:int = 30;
      
      protected var _1695630442yOffsetFirstRow:int = 0;
      
      protected var _1975517254yOffsetSecondRow:int = 25;
      
      protected var _82311551yOffsetThirdRow:int = 50;
      
      protected var _818466732yOffsetFourthRow:int = 75;
      
      protected var _2038614225yOffsetFifthRow:int = 100;
      
      private var moduleList:ArrayList = new ArrayList();
      
      private var _bsWindowMode:String = "AsteroidState";
      
      public function ModuleInstallationViewBase()
      {
         super();
      }
      
      protected function creationCompleteHandler() : void
      {
         this.updateLocalModuleList();
         this.titleLabel.text = BPLocale.getItem("label_bswin_mod_installation");
      }
      
      protected function handleDragEntered(param1:DragEvent) : void
      {
         var _loc2_:ModuleItem = this.getModuleItem(param1);
         _loc2_.hovered = true;
         DragManager.acceptDragDrop(param1.currentTarget as IUIComponent);
      }
      
      protected function handleDragExit(param1:DragEvent) : void
      {
         var _loc2_:ModuleItem = this.getModuleItem(param1);
         _loc2_.hovered = false;
         DragManager.acceptDragDrop(param1.currentTarget as IUIComponent);
      }
      
      protected function handleDroppedModule(param1:DragEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:BattleStationWindowEvent = null;
         var _loc2_:ModuleVO = param1.dragSource.dataForFormat("moduleData") as ModuleVO;
         if(_loc2_)
         {
            if(param1.currentTarget is ModuleHolster)
            {
               if(ModuleHolster(param1.currentTarget).moduleItem.isInstalling)
               {
                  return;
               }
               _loc3_ = ModuleHolster(param1.currentTarget).slotId;
               _loc4_ = ModuleHolster(param1.currentTarget).moduleItem.moduleType;
               ModuleHolster(param1.currentTarget).moduleItem.hovered = false;
               ModuleHolster(param1.currentTarget).moduleItem.isInstalling = true;
            }
            else if(param1.currentTarget is ModuleItem)
            {
               if(ModuleItem(param1.currentTarget).isInstalling)
               {
                  return;
               }
               _loc3_ = ModuleItem(param1.currentTarget).slotId;
               _loc4_ = ModuleItem(param1.currentTarget).moduleType;
               ModuleItem(param1.currentTarget).hovered = false;
            }
            _loc5_ = new BattleStationWindowEvent(BattleStationWindowEvent.EQUIP_MODULE);
            _loc5_.itemId = _loc2_.itemId;
            _loc5_.slotId = _loc3_;
            _loc5_.replaceFlag = _loc4_ > 1;
            dispatchEvent(_loc5_);
         }
      }
      
      protected function handleModuleClicked(param1:MouseEvent) : void
      {
         var _loc3_:BattleStationWindowEvent = null;
         var _loc2_:ModuleItem = this.getModuleItem(param1);
         if(Boolean(_loc2_ && _loc2_.moduleVO) && Boolean(_loc2_.moduleVO) && Boolean(_loc2_.moduleVO.type))
         {
            if(!_loc2_.duringRepair)
            {
               _loc3_ = new BattleStationWindowEvent(BattleStationWindowEvent.BATTLE_STATION_MODULE_CLICKED);
               _loc3_.itemId = _loc2_.itemId;
               _loc3_.slotId = _loc2_.slotId;
               _loc3_.moduleType = _loc2_.moduleType;
               _loc3_.moduleItem = _loc2_;
               dispatchEvent(_loc3_);
            }
         }
      }
      
      protected function handleModuleRoll(param1:MouseEvent) : void
      {
         var _loc2_:ModuleItem = this.getModuleItem(param1);
         if(Boolean(_loc2_) && Boolean(_loc2_.moduleVO) && this._bsWindowMode != ModuleItemBase.INSTALLING_STATE)
         {
            if(_loc2_.duringRepair == false && _loc2_.moduleVO.type != 0)
            {
               _loc2_.checkRepairIconSource();
               TweenMax.to(_loc2_.repairIcon,0.3,{"autoAlpha":int(param1.type == MouseEvent.ROLL_OVER)});
            }
         }
      }
      
      private function getModuleItem(param1:MouseEvent) : ModuleItem
      {
         if(param1.currentTarget is ModuleHolster)
         {
            return ModuleHolster(param1.currentTarget).moduleItem;
         }
         if(param1.currentTarget is ModuleItem)
         {
            return ModuleItem(param1.currentTarget);
         }
         return null;
      }
      
      private function updateLocalModuleList() : void
      {
         this.moduleList.addItemAt(this.hub,this.hub.slotId);
         this.moduleList.addItemAt(this.hub,this.hub.slotId2);
         this.moduleList.addItemAt(this.rightInner1,this.rightInner1.slotId);
         this.moduleList.addItemAt(this.rightOuter1,this.rightOuter1.slotId);
         this.moduleList.addItemAt(this.rightOuter2,this.rightOuter2.slotId);
         this.moduleList.addItemAt(this.rightInner2,this.rightInner2.slotId);
         this.moduleList.addItemAt(this.leftInner2,this.leftInner2.slotId);
         this.moduleList.addItemAt(this.leftOuter2,this.leftOuter2.slotId);
         this.moduleList.addItemAt(this.leftOuter1,this.leftOuter1.slotId);
         this.moduleList.addItemAt(this.leftInner1,this.leftInner1.slotId);
      }
      
      public function initInstalledModules(param1:String, param2:Vector.<ModuleVO>) : void
      {
         this.initInstalledModulesCalledLater(param1,param2);
      }
      
      private function initInstalledModulesCalledLater(param1:String, param2:Vector.<ModuleVO>) : void
      {
         var _loc4_:ModuleHolster = null;
         var _loc5_:ModuleVO = null;
         var _loc6_:ModuleVO = null;
         this._bsWindowMode = param1;
         if(!this.moduleList.length)
         {
            this.updateLocalModuleList();
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = this.moduleList.getItemAt(_loc3_) as ModuleHolster;
            _loc5_ = param2[_loc3_];
            _loc4_.secondModuleItem.asteroidMode = _loc4_.moduleItem.asteroidMode = true;
            _loc4_.moduleItem.state = _loc4_.secondModuleItem.state = this._bsWindowMode;
            _loc4_.setModuleState(this._bsWindowMode);
            if(_loc3_ == 1)
            {
               _loc4_.setSecondModuleStuff(_loc5_.type,_loc5_.itemId);
               _loc4_.secondModuleItem.itemId = _loc5_.itemId;
               _loc4_.secondModuleItem.moduleVO = _loc5_;
               if(_loc5_.installationSecondsLeft > 0)
               {
                  _loc4_.secondModuleItem.setProgressBarProgress(_loc5_.installationSecondsLeft,_loc5_.installationSecondsTotal);
                  _loc4_.secondModuleItem.progressVisibility = true;
               }
               else
               {
                  _loc4_.secondModuleItem.progressVisibility = false;
               }
            }
            else
            {
               _loc4_.moduleItem.itemId = _loc5_.itemId;
               _loc4_.moduleItem.moduleVO = _loc5_;
               if(_loc5_.installationSecondsLeft > 0)
               {
                  _loc4_.moduleItem.setProgressBarProgress(_loc5_.installationSecondsLeft,_loc5_.installationSecondsTotal);
                  _loc4_.moduleItem.progressVisibility = true;
               }
               else
               {
                  _loc4_.moduleItem.progressVisibility = false;
               }
            }
            if(_loc5_.type == ModuleVO.HULL || _loc5_.type == ModuleVO.DEFLECTOR)
            {
               _loc6_ = this.getModuleVOByType(ModuleVO.HULL,param2);
               if(_loc6_)
               {
                  if(_loc4_.moduleItem.moduleVO)
                  {
                     _loc4_.moduleItem.moduleVO.emergencyRepairSecondsLeft = _loc6_.emergencyRepairSecondsLeft;
                  }
                  if(_loc4_.secondModuleItem.moduleVO)
                  {
                     _loc4_.secondModuleItem.moduleVO.emergencyRepairSecondsLeft = _loc6_.emergencyRepairSecondsLeft;
                  }
               }
            }
            callLater(_loc4_.secondModuleItem.initIcon);
            callLater(_loc4_.moduleItem.initIcon);
            if(_loc5_.type != ModuleVO.DEFLECTOR)
            {
               _loc4_.setShieldAndHitpoints(_loc5_.currentHitpoints,_loc5_.maxHitpoints,_loc5_.currentShield,_loc5_.maxShield);
            }
            _loc3_++;
         }
      }
      
      private function getModuleVOByType(param1:int, param2:Vector.<ModuleVO>) : ModuleVO
      {
         var _loc3_:ModuleVO = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.type == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function updateInstalledModule(param1:ModuleVO) : void
      {
         var _loc2_:ModuleHolster = null;
         try
         {
            _loc2_ = this.moduleList.getItemAt(param1.slotOccupying) as ModuleHolster;
         }
         catch(e:Error)
         {
         }
         if(Boolean(_loc2_) && Boolean(_loc2_.moduleItem))
         {
            _loc2_.setShieldAndHitpoints(param1.currentHitpoints,param1.maxHitpoints,param1.currentShield,param1.maxShield);
            if(param1.emergencyRepairSecondsLeft > 0)
            {
               _loc2_.moduleItem.startRepair();
               if(param1.slotOccupying == 0 || param1.slotOccupying == 1)
               {
                  _loc2_.secondModuleItem.startRepair();
               }
            }
            else
            {
               _loc2_.moduleItem.stopRepair();
               if(_loc2_.secondModuleItem)
               {
                  _loc2_.secondModuleItem.stopRepair();
               }
            }
            if(param1.type == _loc2_.moduleItem.moduleVO.type)
            {
               _loc2_.moduleItem.moduleVO.updateInstallacionTime(param1.installationSecondsLeft);
            }
            _loc2_.moduleItem.moduleVO.update(param1.emergencyRepairSecondsLeft,param1.emergencyRepairSecondsTotal,param1.currentHitpoints,param1.currentShield);
            if(Boolean(_loc2_.secondModuleItem) && Boolean(_loc2_.secondModuleItem.moduleVO))
            {
               _loc2_.secondModuleItem.moduleVO.update(param1.emergencyRepairSecondsLeft,param1.emergencyRepairSecondsTotal,param1.currentHitpoints,param1.currentShield);
               if(param1.type == _loc2_.secondModuleItem.moduleVO.type)
               {
                  _loc2_.secondModuleItem.moduleVO.updateInstallacionTime(param1.installationSecondsLeft);
               }
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get titleLabel() : Label
      {
         return this._1791483012titleLabel;
      }
      
      public function set titleLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1791483012titleLabel;
         if(_loc2_ !== param1)
         {
            this._1791483012titleLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftInner1() : ModuleHolster
      {
         return this._1826203522leftInner1;
      }
      
      public function set leftInner1(param1:ModuleHolster) : void
      {
         var _loc2_:Object = this._1826203522leftInner1;
         if(_loc2_ !== param1)
         {
            this._1826203522leftInner1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftInner1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightInner1() : ModuleHolster
      {
         return this._702536233rightInner1;
      }
      
      public function set rightInner1(param1:ModuleHolster) : void
      {
         var _loc2_:Object = this._702536233rightInner1;
         if(_loc2_ !== param1)
         {
            this._702536233rightInner1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightInner1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftOuter1() : ModuleHolster
      {
         return this._2004621821leftOuter1;
      }
      
      public function set leftOuter1(param1:ModuleHolster) : void
      {
         var _loc2_:Object = this._2004621821leftOuter1;
         if(_loc2_ !== param1)
         {
            this._2004621821leftOuter1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftOuter1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightOuter1() : ModuleHolster
      {
         return this._524117934rightOuter1;
      }
      
      public function set rightOuter1(param1:ModuleHolster) : void
      {
         var _loc2_:Object = this._524117934rightOuter1;
         if(_loc2_ !== param1)
         {
            this._524117934rightOuter1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightOuter1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hub() : ModuleHolster
      {
         return this._103669hub;
      }
      
      public function set hub(param1:ModuleHolster) : void
      {
         var _loc2_:Object = this._103669hub;
         if(_loc2_ !== param1)
         {
            this._103669hub = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hub",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftOuter2() : ModuleHolster
      {
         return this._2004621822leftOuter2;
      }
      
      public function set leftOuter2(param1:ModuleHolster) : void
      {
         var _loc2_:Object = this._2004621822leftOuter2;
         if(_loc2_ !== param1)
         {
            this._2004621822leftOuter2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftOuter2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightOuter2() : ModuleHolster
      {
         return this._524117933rightOuter2;
      }
      
      public function set rightOuter2(param1:ModuleHolster) : void
      {
         var _loc2_:Object = this._524117933rightOuter2;
         if(_loc2_ !== param1)
         {
            this._524117933rightOuter2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightOuter2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftInner2() : ModuleHolster
      {
         return this._1826203523leftInner2;
      }
      
      public function set leftInner2(param1:ModuleHolster) : void
      {
         var _loc2_:Object = this._1826203523leftInner2;
         if(_loc2_ !== param1)
         {
            this._1826203523leftInner2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftInner2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightInner2() : ModuleHolster
      {
         return this._702536232rightInner2;
      }
      
      public function set rightInner2(param1:ModuleHolster) : void
      {
         var _loc2_:Object = this._702536232rightInner2;
         if(_loc2_ !== param1)
         {
            this._702536232rightInner2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightInner2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get xOffsetInnerModules() : int
      {
         return this._860014364xOffsetInnerModules;
      }
      
      protected function set xOffsetInnerModules(param1:int) : void
      {
         var _loc2_:Object = this._860014364xOffsetInnerModules;
         if(_loc2_ !== param1)
         {
            this._860014364xOffsetInnerModules = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xOffsetInnerModules",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get xOffsetOuterModules() : int
      {
         return this._761672023xOffsetOuterModules;
      }
      
      protected function set xOffsetOuterModules(param1:int) : void
      {
         var _loc2_:Object = this._761672023xOffsetOuterModules;
         if(_loc2_ !== param1)
         {
            this._761672023xOffsetOuterModules = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xOffsetOuterModules",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get yOffsetInnerModules() : int
      {
         return this._15542493yOffsetInnerModules;
      }
      
      protected function set yOffsetInnerModules(param1:int) : void
      {
         var _loc2_:Object = this._15542493yOffsetInnerModules;
         if(_loc2_ !== param1)
         {
            this._15542493yOffsetInnerModules = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yOffsetInnerModules",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get yOffsetOuterModules() : int
      {
         return this._82799848yOffsetOuterModules;
      }
      
      protected function set yOffsetOuterModules(param1:int) : void
      {
         var _loc2_:Object = this._82799848yOffsetOuterModules;
         if(_loc2_ !== param1)
         {
            this._82799848yOffsetOuterModules = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yOffsetOuterModules",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get yOffsetFirstRow() : int
      {
         return this._1695630442yOffsetFirstRow;
      }
      
      protected function set yOffsetFirstRow(param1:int) : void
      {
         var _loc2_:Object = this._1695630442yOffsetFirstRow;
         if(_loc2_ !== param1)
         {
            this._1695630442yOffsetFirstRow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yOffsetFirstRow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get yOffsetSecondRow() : int
      {
         return this._1975517254yOffsetSecondRow;
      }
      
      protected function set yOffsetSecondRow(param1:int) : void
      {
         var _loc2_:Object = this._1975517254yOffsetSecondRow;
         if(_loc2_ !== param1)
         {
            this._1975517254yOffsetSecondRow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yOffsetSecondRow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get yOffsetThirdRow() : int
      {
         return this._82311551yOffsetThirdRow;
      }
      
      protected function set yOffsetThirdRow(param1:int) : void
      {
         var _loc2_:Object = this._82311551yOffsetThirdRow;
         if(_loc2_ !== param1)
         {
            this._82311551yOffsetThirdRow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yOffsetThirdRow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get yOffsetFourthRow() : int
      {
         return this._818466732yOffsetFourthRow;
      }
      
      protected function set yOffsetFourthRow(param1:int) : void
      {
         var _loc2_:Object = this._818466732yOffsetFourthRow;
         if(_loc2_ !== param1)
         {
            this._818466732yOffsetFourthRow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yOffsetFourthRow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get yOffsetFifthRow() : int
      {
         return this._2038614225yOffsetFifthRow;
      }
      
      protected function set yOffsetFifthRow(param1:int) : void
      {
         var _loc2_:Object = this._2038614225yOffsetFifthRow;
         if(_loc2_ !== param1)
         {
            this._2038614225yOffsetFifthRow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yOffsetFifthRow",_loc2_,param1));
            }
         }
      }
   }
}

