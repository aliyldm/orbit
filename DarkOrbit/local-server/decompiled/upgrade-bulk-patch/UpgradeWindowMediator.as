package net.bigpoint.darkorbit.mvc.crafting.upgrade.view
{
   import Infinicast.Runtime.StringUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.AssemblyBuildRequest;
   import net.bigpoint.darkorbit.com.module.AssemblyCollectAllRequest;
   import net.bigpoint.darkorbit.com.module.AssemblyCollectRequest;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblySkipRequest;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterSettingsVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterViewController;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.DropDownList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListDecorator;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui.RecipeFilterViewController;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.UpgradeNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeModel;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeRecipeItemPair;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeModel;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.UpgradeView;
   
   public class UpgradeWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "UpgradeWindowMediator";
      
      public static const NO_ITEMS_IN_FILTER_VIEW:String = NAME + "NO_ITEMS_IN_FILTER_VIEW";
      
      public static const STANDARD_VIEW:String = NAME + "STANDARD_VIEW";
      
      private static const EMPTY:Vector.<UpgradeTypeModel> = new Vector.<UpgradeTypeModel>(0);
      
      private var _vectorCollection:VectorCollection;
      
      private var _filterView:RecipeFilterViewController;
      
      private var _currentTypeIndex:int;
      
      private var _currentItemIndex:int;
      
      private var _comps:UpgradeView;
      
      private var _upgradeModel:UpgradeModel;
      
      private var _selectedUpgradeTypeVo:UpgradeTypeModel;
      
      private var _selectedTarget:UpgradeRecipeItemPair;
      
      private var _filterUpdatePointer:uint;
      
      private var _filterSettingsVO:ItemFilterSettingsVO;
      
      private var _window:SimpleWindow;
      
      private var _updateTargetListTimerId:uint;
      
      public function UpgradeWindowMediator(param1:Sprite, param2:SimpleWindow)
      {
         super(NAME,param1);
         this._window = param2;
         param1.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
         this._filterView = new RecipeFilterViewController(FuiComponentSelectorUtil.selectComponent("contentContainer.filterComboboxContainer",this.view));
         this._filterView.addEventListener(ItemFilterViewController.SETTINGS_CHANGED_EVENT,this.handleFilterSettingsChangedEvent);
         this._comps = new UpgradeView(this.view);
         this._comps.upgradeTargetBuildComponents.buildClicked.add(this.handleBuildClicked);
         this._comps.upgradeTargetBuildComponents.collectClicked.add(this.handleCollectClicked);
         this._comps.upgradeTargetBuildComponents.skipClicked.add(this.handleSkipClicked);
         this._comps.upgradeTargetBuildComponents.selectedItemRecipesDropDown.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleRecipeSelectionChanged);
         this._comps.upgradeTargetGridComponents.collectAllBtn.addEventListener(MouseEvent.CLICK,this.handleCollectAllClicked);
         new ItemListDecorator(this._comps.upgradeTargetTypeComponents.upgradeTargetTypeList);
         this._comps.upgradeTargetTypeComponents.upgradeTargetListLeft.addEventListener(MouseEvent.CLICK,this.handleLeftClicked);
         this._comps.upgradeTargetTypeComponents.upgradeTargetListRight.addEventListener(MouseEvent.CLICK,this.handleRightClicked);
      }
      
      private var _bulkWeapons:Boolean = false;
      private var _bulkShields:Boolean = false;
      private var _bulkVersion:uint = 0;
      private var _bulkQuote:Object = null;
      private var _bulkBuilding:Boolean = false;
      private var _bulkLoader:URLLoader;
      private var _bulkExpiryTimer:uint;

      private function bulkButton(name:String) : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.bulkUpgrade." + name,this.view) as Button;
      }

      private function bulkLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.bulkUpgrade.cost",this.view) as Label;
      }

      private function initBulkUpgrade() : void
      {
         if(!this.bulkButton("weapons")) return;
         this.bulkButton("weapons").addEventListener(MouseEvent.CLICK,this.handleBulkWeapons);
         this.bulkButton("shields").addEventListener(MouseEvent.CLICK,this.handleBulkShields);
         this.bulkButton("refresh").addEventListener(MouseEvent.CLICK,this.handleBulkRefresh);
         this.bulkButton("build").addEventListener(MouseEvent.CLICK,this.handleBulkBuild);
         this.drawBulkSelection();
         this.bulkLabel().text = "Maliyet için tüm silahları ve/veya kalkanları seç.";
      }

      private function drawBulkSelection() : void
      {
         this.bulkButton("weapons").text = (this._bulkWeapons ? "[X] " : "[ ] ") + "Tüm silahlar";
         this.bulkButton("shields").text = (this._bulkShields ? "[X] " : "[ ] ") + "Tüm kalkanlar";
         this.bulkButton("weapons").enabled = !this._bulkBuilding;
         this.bulkButton("shields").enabled = !this._bulkBuilding;
         this.bulkButton("refresh").enabled = !this._bulkBuilding;
         this.bulkButton("build").enabled = !this._bulkBuilding && this._bulkQuote != null && this._bulkQuote.canBuild == true;
      }

      private function handleBulkWeapons(event:MouseEvent) : void
      {
         if(this._bulkBuilding) return;
         this._bulkWeapons = !this._bulkWeapons;
         this.refreshBulkQuote();
      }

      private function handleBulkShields(event:MouseEvent) : void
      {
         if(this._bulkBuilding) return;
         this._bulkShields = !this._bulkShields;
         this.refreshBulkQuote();
      }

      private function handleBulkRefresh(event:MouseEvent) : void
      {
         if(!this._bulkBuilding) this.refreshBulkQuote();
      }

      private function refreshBulkQuote() : void
      {
         clearTimeout(this._bulkExpiryTimer);
         this._bulkQuote = null;
         this._bulkVersion++;
         this.drawBulkSelection();
         if(!this._bulkWeapons && !this._bulkShields)
         {
            this.bulkLabel().text = "Maliyet için tüm silahları ve/veya kalkanları seç.";
            return;
         }
         this.bulkLabel().text = "Toplam Upgrade Module maliyeti hesaplanıyor...";
         this.requestBulkUpgrade("quote","");
      }

      private function handleBulkBuild(event:MouseEvent) : void
      {
         if(this._bulkBuilding || this._bulkQuote == null || this._bulkQuote.canBuild != true) return;
         if(new Date().time >= Number(this._bulkQuote.expiresAt))
         {
            this.refreshBulkQuote();
            return;
         }
         var token:String = String(this._bulkQuote.token);
         clearTimeout(this._bulkExpiryTimer);
         this._bulkQuote = null;
         this._bulkBuilding = true;
         this.drawBulkSelection();
         this.bulkLabel().text = "Seçilen eşyalar maksimum seviyeleri için başlatılıyor...";
         this.requestBulkUpgrade("build",token);
      }

      private function requestBulkUpgrade(action:String, token:String) : void
      {
         if(this._bulkLoader != null)
         {
            try { this._bulkLoader.close(); } catch(ignored:Error) {}
         }
         var loader:URLLoader = new URLLoader();
         this._bulkLoader = loader;
         var version:uint = this._bulkVersion;
         var variables:URLVariables = new URLVariables();
         variables.action = action;
         if(action == "quote")
         {
            var categories:Array = [];
            if(this._bulkWeapons) categories.push("weapons");
            if(this._bulkShields) categories.push("shields");
            variables.categories = categories.join(",");
         }
         else variables.token = token;
         var request:URLRequest = new URLRequest("http://127.0.0.1:8095/ajax/upgrade-bulk.php");
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader.addEventListener(Event.COMPLETE,function(event:Event):void
         {
            if(version != _bulkVersion) return;
            _bulkLoader = null;
            _bulkBuilding = false;
            try
            {
               var response:Object = JSON.parse(String(loader.data));
               if(response.ok != true)
               {
                  _bulkQuote = null;
                  bulkLabel().text = response.message ? String(response.message) : "İşlem tamamlanamadı. Yenile.";
               }
               else if(action == "quote")
               {
                  _bulkQuote = response;
                  bulkLabel().text = String(response.itemCount) + " eşya · Toplam " + String(response.totalModules) + " Upgrade Module\nSende: " + String(response.availableModules) + (response.canBuild ? " · Her eşya kendi maksimumuna" : " · " + String(response.message || "Modül yetersiz / uygun eşya yok"));
                  _bulkExpiryTimer = setTimeout(expireBulkQuote,Math.max(1,Number(response.expiresAt) - new Date().time));
               }
               else
               {
                  _bulkQuote = null;
                  bulkLabel().text = response.message ? String(response.message) : "Toplu geliştirme başlatıldı. Süre sonunda Tümünü topla.";
               }
            }
            catch(error:Error)
            {
               _bulkQuote = null;
               bulkLabel().text = "Sunucu yanıtı okunamadı. Durumu yenile.";
            }
            drawBulkSelection();
         });
         var failed:Function = function(event:Event):void
         {
            if(version != _bulkVersion) return;
            _bulkLoader = null;
            _bulkQuote = null;
            _bulkBuilding = false;
            bulkLabel().text = "Bağlantı kurulamadı. Durumu yenile.";
            drawBulkSelection();
         };
         loader.addEventListener(IOErrorEvent.IO_ERROR,failed);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         try { loader.load(request); }
         catch(error:Error) { failed(null); }
      }

      private function expireBulkQuote() : void
      {
         this._bulkQuote = null;
         this.bulkLabel().text = "Maliyet süresi doldu. Başlatmadan önce Yenile.";
         this.drawBulkSelection();
      }

      private function handleRightClicked(param1:MouseEvent) : void
      {
         var _loc2_:ItemList = this._comps.upgradeTargetTypeComponents.upgradeTargetTypeList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() + _loc2_.getScrollOnePageAmount());
      }
      
      private function handleLeftClicked(param1:MouseEvent) : void
      {
         var _loc2_:ItemList = this._comps.upgradeTargetTypeComponents.upgradeTargetTypeList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() - _loc2_.getScrollOnePageAmount());
      }
      
      public function set itemFilterSettings(param1:ItemFilterSettingsVO) : void
      {
         this._filterView.itemFilterSettings = this._filterSettingsVO = param1;
         this.invalidateTargets();
      }
      
      private function set selectedTarget(param1:UpgradeRecipeItemPair) : void
      {
         if(this._selectedTarget)
         {
            this._selectedTarget.changed.remove(this.handleSelectedTargetChanged);
            this._selectedTarget.item.itemVOChanged.remove(this.handleSelectedTargetChanged);
         }
         this._selectedTarget = param1;
         if(this._selectedTarget)
         {
            this._selectedTarget.changed.add(this.handleSelectedTargetChanged);
            this._selectedTarget.item.itemVOChanged.add(this.handleSelectedTargetChanged);
         }
         this.handleSelectedTargetChanged();
      }
      
      private function get activeRecipe() : TargetItemRecipeModel
      {
         if(this._selectedUpgradeTypeVo.recipes.length == 1)
         {
            return this._selectedUpgradeTypeVo.recipes[0] as TargetItemRecipeModel;
         }
         if(this._selectedUpgradeTypeVo.recipes.length > 1)
         {
            return this._comps.upgradeTargetBuildComponents.selectedItemRecipesDropDown.selectedItem as TargetItemRecipeModel || this._selectedUpgradeTypeVo.recipes[0] as TargetItemRecipeModel;
         }
         return null;
      }
      
      private function set selectedUpgradeTypeVo(param1:UpgradeTypeModel) : void
      {
         if(this._selectedUpgradeTypeVo)
         {
            this._selectedUpgradeTypeVo.changed.remove(this.updateGridList);
            this._selectedUpgradeTypeVo.hasCollectibleRecipe.changed.remove(this.collectibleRecipeChanged);
         }
         this._selectedUpgradeTypeVo = param1;
         if(this._selectedUpgradeTypeVo)
         {
            this._selectedUpgradeTypeVo.changed.add(this.updateGridList);
            this._selectedUpgradeTypeVo.hasCollectibleRecipe.changed.add(this.collectibleRecipeChanged);
            this.collectibleRecipeChanged();
            this.updateGridList();
         }
      }
      
      private function collectibleRecipeChanged() : void
      {
         this._comps.upgradeTargetGridComponents.collectAllBtn.enabled = this._selectedUpgradeTypeVo.hasCollectibleRecipe.value;
      }
      
      private function get view() : Container
      {
         return viewComponent as Container;
      }
      
      override public function onRegister() : void
      {
         this._comps.upgradeTargetTypeComponents.upgradeTargetTypeList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.targetTypeSelectionChanged);
         this._comps.upgradeTargetGridComponents.upgradeTargetsGrid.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.targetSelectionChanged);
         this._upgradeModel = retrieveProxy(UpgradeProxy.NAME).getData() as UpgradeModel;
         this._upgradeModel.changed.add(this.invalidateTargets);
         this.initBulkUpgrade();
         this.invalidateTargets();
      }
      
      public function filter(param1:Vector.<UpgradeTypeModel>) : Vector.<UpgradeTypeModel>
      {
         if(this._filterSettingsVO == null)
         {
            return EMPTY;
         }
         return this.filterItems(param1,this._filterSettingsVO.getAllSelectedItemTypes());
      }
      
      protected function filterItems(param1:Vector.<UpgradeTypeModel>, param2:Dictionary) : Vector.<UpgradeTypeModel>
      {
         var _loc6_:UpgradeTypeModel = null;
         var _loc3_:Vector.<UpgradeTypeModel> = new Vector.<UpgradeTypeModel>();
         var _loc4_:uint = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_];
            if((Boolean(param2[_loc6_.targetItemType.typeClass]) || Boolean(param2[_loc6_.targetItemType.typeClass + "." + _loc6_.targetItemType.typeValue])) && !StringUtils.startsWith(_loc6_.recipes[0].lootId,AssemblyConsts.LOCKUPGRADEPREFIX))
            {
               _loc3_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      protected function switchView(param1:String) : void
      {
         if(param1 == NO_ITEMS_IN_FILTER_VIEW)
         {
            this._comps.standardViewContainer.visible = false;
            this._comps.filterEmptyItemsContainer.visible = true;
         }
         else if(param1 == STANDARD_VIEW)
         {
            this._comps.standardViewContainer.visible = true;
            this._comps.filterEmptyItemsContainer.visible = false;
         }
      }
      
      private function handleCollectClicked(param1:String, param2:Number) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblyCollectRequest(param2,param1));
      }
      
      private function handleSkipClicked(param1:String, param2:Number) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblySkipRequest(param1,param2));
      }
      
      private function handleBuildClicked(param1:String, param2:int, param3:Number) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblyBuildRequest(param1,param2,param3));
      }
      
      private function saveFilter() : void
      {
         facade.sendNotification(UpgradeNotifications.SAVE_UPGRADE_FILTER_SETTINGS);
         this.invalidateTargets();
      }
      
      private function handleSelectedTargetChanged() : void
      {
         if(!this._selectedTarget || !this._selectedTarget.item)
         {
            this._comps.upgradeTargetBuildComponents.selectedItemLevel.text = "";
            this._comps.upgradeTargetBuildComponents.hideAll();
            return;
         }
         this._comps.upgradeTargetBuildComponents.selectedItemLevel.text = ItemsDataUtility.getDisplayUpgradeLevel(this._selectedTarget.item).toString();
         this._comps.upgradeTargetBuildComponents.showUpgrade(this._selectedTarget,this.activeRecipe);
      }
      
      private function updateGridList() : void
      {
         this._currentItemIndex = Math.max(this._comps.upgradeTargetGridComponents.upgradeTargetsGrid.selectedIndex,0);
         this._comps.upgradeTargetGridComponents.upgradeTargetsGrid.list = new VectorCollection(this._selectedUpgradeTypeVo.targetsLevelSorted);
         var _loc1_:DropDownList = this._comps.upgradeTargetBuildComponents.selectedItemRecipesDropDown;
         _loc1_.list = new VectorCollection(this._selectedUpgradeTypeVo.recipes);
         var _loc2_:Boolean = this._selectedUpgradeTypeVo.recipes.length > 1;
         _loc1_.visible = _loc2_;
         setTimeout(this.setSelectedGridItem,1);
      }
      
      private function setSelectedGridItem() : void
      {
         var _loc1_:Number = this._comps.upgradeTargetGridComponents.upgradeTargetsGrid.list.indexOf(this._selectedTarget);
         if(_loc1_ == -1)
         {
            _loc1_ = Math.max(Math.min(this._currentItemIndex,this._comps.upgradeTargetGridComponents.upgradeTargetsGrid.list.length - 1),0);
         }
         this._comps.upgradeTargetGridComponents.upgradeTargetsGrid.selectedIndex = _loc1_;
      }
      
      private function updateTargetList() : void
      {
         if(this.view.stage)
         {
            this.setUpdateTargetItems(this._upgradeModel.availableUpgradeTypes);
         }
         else
         {
            this.setUpdateTargetItems(EMPTY);
         }
      }
      
      private function setUpdateTargetItems(param1:Vector.<UpgradeTypeModel>) : void
      {
         param1 = this.filter(param1.filter(UpgradeTypeModel.filterEmpty));
         if(param1.length == 0)
         {
            this.switchView(NO_ITEMS_IN_FILTER_VIEW);
         }
         else
         {
            this.switchView(STANDARD_VIEW);
         }
         if(!this._vectorCollection)
         {
            this._currentTypeIndex = 0;
            this._vectorCollection = new VectorCollection(param1);
         }
         else
         {
            this._vectorCollection.collection = param1;
            this._currentTypeIndex = Math.min(this._currentTypeIndex,this._vectorCollection.length - 1);
         }
         this._comps.upgradeTargetTypeComponents.upgradeTargetTypeList.list = this._vectorCollection;
         this._comps.upgradeTargetTypeComponents.upgradeTargetTypeList.forceRedraw(uint.MAX_VALUE,true);
         this._comps.upgradeTargetTypeComponents.upgradeTargetListRight.visible = this._comps.upgradeTargetTypeComponents.upgradeTargetListLeft.visible = !this._comps.upgradeTargetTypeComponents.upgradeTargetTypeList.allItemsDisplayed();
         setTimeout(this.setSelection,1);
      }
      
      private function setSelection() : void
      {
         var _loc1_:int = int(this._vectorCollection.collection.indexOf(this._selectedUpgradeTypeVo));
         if(_loc1_ != -1)
         {
            this._currentTypeIndex = _loc1_;
         }
         else
         {
            this._currentTypeIndex = 0;
         }
         this._comps.upgradeTargetTypeComponents.upgradeTargetTypeList.selectedIndex = this._currentTypeIndex;
      }
      
      private function invalidateTargets() : void
      {
         clearTimeout(this._updateTargetListTimerId);
         this._updateTargetListTimerId = setTimeout(this.updateTargetList,1);
      }
      
      protected function handleFilterSettingsChangedEvent(param1:Event) : void
      {
         clearTimeout(this._filterUpdatePointer);
         this._filterUpdatePointer = setTimeout(this.saveFilter,100);
      }
      
      private function handleCollectAllClicked(param1:MouseEvent) : void
      {
         var _loc6_:UpgradeRecipeItemPair = null;
         var _loc2_:AssemblyCollectAllRequest = new AssemblyCollectAllRequest();
         var _loc3_:Vector.<UpgradeRecipeItemPair> = this._selectedUpgradeTypeVo.targets;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(Boolean(_loc6_.item) && Boolean(_loc6_.recipe) && _loc6_.recipe.state.status.getLibcomModuleId() == AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId())
            {
               _loc2_.allRequests.push(new AssemblyCollectRequest(_loc6_.item.id,_loc6_.recipe.lootId));
            }
            _loc5_++;
         }
         if(_loc2_.allRequests.length > 0)
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
         }
      }
      
      private function targetSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc2_:UpgradeRecipeItemPair = param1.itemVO as UpgradeRecipeItemPair;
         this.selectedTarget = _loc2_;
      }
      
      private function targetTypeSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc2_:UpgradeTypeModel = param1.itemVO as UpgradeTypeModel;
         this.selectedUpgradeTypeVo = _loc2_;
      }
      
      private function handleRecipeSelectionChanged(param1:Event) : void
      {
         this.handleSelectedTargetChanged();
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         this._filterView.close();
         this.invalidateTargets();
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.invalidateTargets();
      }
   }
}

