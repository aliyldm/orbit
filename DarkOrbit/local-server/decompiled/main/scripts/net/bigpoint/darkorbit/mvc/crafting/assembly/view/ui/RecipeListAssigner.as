package net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeAttributes;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyTimerState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.types.AssemblyTemporaryType;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RecipeListAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _timed:Coreponent;
      
      private var _building:Coreponent;
      
      private var _collect:Coreponent;
      
      private var _multibuild:Coreponent;
      
      private var _craftable:Coreponent;
      
      private var _progress:ProgressBar;
      
      private var _progressTimer:ProgressBar;
      
      private var _new:Coreponent;
      
      public function RecipeListAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeCallbacks();
            this.removeSignalListeners();
            super.data = param1;
            if(param1)
            {
               this.update(param1 as AssemblyRecipeModel);
            }
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
         this._timed = FuiComponentSelectorUtil.selectComponent("timed",this) as Coreponent;
         this._building = FuiComponentSelectorUtil.selectComponent("building",this) as Coreponent;
         this._collect = FuiComponentSelectorUtil.selectComponent("collect",this) as Coreponent;
         this._multibuild = FuiComponentSelectorUtil.selectComponent("multibuild",this) as Coreponent;
         this._craftable = FuiComponentSelectorUtil.selectComponent("craftable",this) as Coreponent;
         this._new = FuiComponentSelectorUtil.selectComponent("isNew",this) as Coreponent;
         this._progress = FuiComponentSelectorUtil.selectComponent("progress",this) as ProgressBar;
         this._progressTimer = FuiComponentSelectorUtil.selectComponent("progress_timer",this) as ProgressBar;
         this._timed.visible = this._building.visible = this._collect.visible = this._multibuild.visible = this._craftable.visible = this._progressTimer.visible = false;
      }
      
      override protected function drawSelection() : void
      {
         var _loc1_:AssemblyRecipeModel = null;
         var _loc2_:AssemblyRecipeAvailableStatusModule = null;
         super.drawSelection();
         if(_selected)
         {
            _loc1_ = data as AssemblyRecipeModel;
            if(Boolean(_loc1_) && _loc1_.state.status.getLibcomModuleId() == AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId())
            {
               _loc2_ = _loc1_.state.status as AssemblyRecipeAvailableStatusModule;
               if(_loc2_.isNew)
               {
                  dispatchEvent(new MouseEvent(AssemblyConsts.EVENT_FIRST_SELECTION));
                  _loc2_.isNew = false;
               }
               TweenMax.killTweensOf(this._new,true);
               this._new.visible = false;
            }
         }
         this._hover.enabled = !_selected;
      }
      
      override public function dispose() : void
      {
         this.removeSignalListeners();
         super.dispose();
      }
      
      private function removeCallbacks() : void
      {
         var _loc1_:AssemblyRecipeModel = data as AssemblyRecipeModel;
         if(!_loc1_)
         {
            return;
         }
         removeLoadResourceCallback(_loc1_.outPutItem.getLoot30x30(Hero.factionName),this.handleItemLoaded,AssetsProxy.ITEMS);
      }
      
      private function update(param1:AssemblyRecipeModel) : void
      {
         tooltipData = param1.itemVO.fullname;
         loadResource(param1.outPutItem.getLoot30x30(Hero.factionName),this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this.addSignalListeners();
         this.updateStates();
      }
      
      private function addSignalListeners() : void
      {
         var _loc5_:AssemblyLootCount = null;
         var _loc1_:AssemblyRecipeModel = data as AssemblyRecipeModel;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.stateChanged.add(this.updateStates);
         var _loc2_:Vector.<AssemblyLootCount> = _loc1_.ingredients;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc5_.count.changed.add(this.updateStates);
            _loc4_++;
         }
      }
      
      private function removeSignalListeners() : void
      {
         var _loc5_:AssemblyLootCount = null;
         var _loc1_:AssemblyRecipeModel = data as AssemblyRecipeModel;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.stateChanged.remove(this.updateStates);
         var _loc2_:Vector.<AssemblyLootCount> = _loc1_.ingredients;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc5_.count.changed.remove(this.updateStates);
            _loc4_++;
         }
      }
      
      private function updateStates() : void
      {
         TweenMax.killTweensOf(this._new,true);
         var _loc1_:AssemblyRecipeModel = data as AssemblyRecipeModel;
         if(!_loc1_)
         {
            return;
         }
         this._timed.visible = _loc1_.type is AssemblyTemporaryType;
         this._progressTimer.visible = this._building.visible = _loc1_.state.status.getLibcomModuleId() == AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId();
         this._collect.visible = _loc1_.state.status.getLibcomModuleId() == AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId();
         this._multibuild.visible = (_loc1_.itemVO.item.attributes as RecipeAttributes).usingStrategy.indexOf("USABLE_ONCE") < 0;
         var _loc2_:Boolean = _loc1_.isBuildAble();
         this._craftable.visible = _loc2_;
         if(_loc1_.state.status.getLibcomModuleId() == AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId())
         {
            this._new.visible = (_loc1_.state.status as AssemblyRecipeAvailableStatusModule).isNew;
            if(this._new.visible)
            {
               TweenMax.to(this._new,1,{
                  "autoAlpha":0,
                  "yoyo":true,
                  "repeat":-1
               });
            }
         }
         else if(_loc1_.state.status.getLibcomModuleId() == AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId())
         {
            (_loc1_.state as AssemblyTimerState).timer.changed.remove(this.updateTimer);
            (_loc1_.state as AssemblyTimerState).timer.changed.add(this.updateTimer);
            this.updateTimer();
         }
         else
         {
            this._new.visible = false;
         }
         if(!_loc2_ && _loc1_.state.status.getLibcomModuleId() == AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId())
         {
            this._progress.visible = true;
            this._progress.currentValue = this.calculateRecipePercantage(_loc1_);
         }
         else
         {
            this._progress.visible = false;
         }
      }
      
      private function updateTimer() : void
      {
         var _loc3_:RecipeAttributes = null;
         var _loc1_:AssemblyRecipeModel = data as AssemblyRecipeModel;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:AssemblyTimerState = _loc1_.state as AssemblyTimerState;
         if(_loc2_)
         {
            _loc3_ = _loc1_.itemVO.item.attributes as RecipeAttributes;
            this._progressTimer.currentValue = 1 - _loc2_.timer.value / (_loc3_.costs[0].buildTimeSec * _loc2_.buildAmount);
         }
      }
      
      private function calculateRecipePercantage(param1:AssemblyRecipeModel) : Number
      {
         var _loc6_:AssemblyLootCount = null;
         var _loc2_:Vector.<AssemblyLootCount> = param1.ingredients;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc4_ += Math.min(_loc6_.count.value / _loc6_.total,1);
            _loc5_++;
         }
         return _loc4_ / _loc3_;
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
   }
}

