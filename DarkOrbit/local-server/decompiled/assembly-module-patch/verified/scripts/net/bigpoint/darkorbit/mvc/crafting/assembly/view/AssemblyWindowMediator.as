package net.bigpoint.darkorbit.mvc.crafting.assembly.view
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.AssemblyBuildRequest;
   import net.bigpoint.darkorbit.com.module.AssemblyCollectRequest;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeSelectRequest;
   import net.bigpoint.darkorbit.com.module.EventActivationStateCommand;
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterSettingsVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterViewController;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBoxEvent;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.IDataReceptible;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListDecorator;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.types.AssemblyTemporaryType;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui.AssemblyInteractionView;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui.IngredientAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui.RecipeFilterViewController;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui.RecipeListAssigner;
   import net.bigpoint.darkorbit.mvc.events.control.notifications.EventNotifications;
   import net.bigpoint.darkorbit.mvc.events.model.EventProxy;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.PermaFrostFissurEvent;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import org.as3commons.lang.StringUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AssemblyWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "AssemblyWindowMediator";
      
      public static const NO_ITEMS_IN_FILTER_VIEW:String = NAME + "NO_ITEMS_IN_FILTER_VIEW";
      
      public static const NO_ITEMS_IN_MODEL_VIEW:String = NAME + "NO_ITEMS_IN_MODEL_VIEW";
      
      public static const STANDARD_VIEW:String = NAME + "STANDARD_VIEW";
      
      private var _window:SimpleWindow;
      
      private var _vectorCollection:VectorCollection;
      
      private var _interactionView:AssemblyInteractionView;
      
      private var _currentRecipe:AssemblyRecipeModel;
      
      private var _filterView:RecipeFilterViewController;
      
      private var _currentIndex:int;
      
      private var _comps:AssemblyComponents;
      
      private var _filterUpdatePointer:uint;
      
      private var _progressCheckbox:CheckBox;
      
      private var _showedExplanationWindowOnce:Boolean = true;
      
      public function AssemblyWindowMediator(param1:Object, param2:SimpleWindow)
      {
         super(NAME,param1);
         this._window = param2;
         param1.addEventListener(Event.ADDED_TO_STAGE,this.tabSelectionChangedHandler);
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.tabSelectionChangedHandler);
         var _loc3_:DisplayObjectContainer = FuiComponentSelectorUtil.selectComponent("contentContainer.filterComboboxContainer",this.view) as Container;
         this._filterView = new RecipeFilterViewController(_loc3_);
         this._filterView.addEventListener(ItemFilterViewController.SETTINGS_CHANGED_EVENT,this.handleFilterSettingsChangedEvent);
         this._interactionView = new AssemblyInteractionView(FuiComponentSelectorUtil.selectComponent("contentContainer.buildContainer.actions",this.view) as Container);
         this._interactionView.buildClicked.add(this.requestBuild);
         this._interactionView.collectClicked.add(this.requestCollect);
         this._comps = new AssemblyComponents(this.view);
         this._window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onMaximized);
         this._window.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.onMinimized);
         new ItemListDecorator(this._comps.recipesList);
         mapNotificationToMethod(AssemblyNotifications.UPDATE_RECIPE_LIST,this.updateRecipes);
         mapNotificationToMethod(AssemblyNotifications.CHANGE_VIEW,this.switchToView);
         mapNotificationToMethod(AssemblyNotifications.WARNING,this.warning);
         this._progressCheckbox = FuiComponentSelectorUtil.selectComponent("contentContainer.filterComboboxContainer.progressButton",this.view) as CheckBox;
         this._progressCheckbox.visible = false;
         this._progressCheckbox.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleProgressCheckBoxClicked);
         mapNotificationToMethod(AssemblyConsts.EVENT_EXPLANATION_WINDOW_CLOSED,this.handleExplanationWindowCloseNotification);
         mapNotificationToMethod(EventNotifications.ACTIVATE_EVENT,this.handleEventActivationNotification);
      }
      
      public function set itemFilterSettings(param1:ItemFilterSettingsVO) : void
      {
         this._filterView.itemFilterSettings = param1;
      }
      
      public function set recipes(param1:Vector.<AssemblyRecipeModel>) : void
      {
         if(!this._vectorCollection)
         {
            this._currentIndex = 0;
            this._vectorCollection = new VectorCollection(param1);
         }
         else
         {
            this._vectorCollection.collection = param1;
            this._currentIndex = Math.min(this._currentIndex,this._vectorCollection.length - 1);
         }
         this.updateBlinking(param1);
         this._comps.recipesList.list = this._vectorCollection;
         this._comps.recipesList.forceRedraw(uint.MAX_VALUE,true);
         this._comps.recipesLeftButton.visible = this._comps.recipesRightButton.visible = !this._comps.recipesList.allItemsDisplayed();
         setTimeout(this.setSelection,1);
      }
      
      private function get view() : Container
      {
         return viewComponent as Container;
      }
      
      override public function onRegister() : void
      {
         this._comps.ingredients.itemDataAssigner = IngredientAssigner;
         this._comps.recipesList.itemDataAssigner = RecipeListAssigner;
         this._comps.recipesList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleSelectionChanged);
         this._comps.recipesList.addEventListener(AssemblyConsts.EVENT_FIRST_SELECTION,this.handleFirstSelection);
         this._comps.recipesLeftButton.addEventListener(MouseEvent.CLICK,this.handleLeftClicked);
         this._comps.recipesRightButton.addEventListener(MouseEvent.CLICK,this.handleRightClicked);
         var _loc1_:EventProxy = this.facade.retrieveProxy(EventProxy.NAME) as EventProxy;
         var _loc2_:PermaFrostFissurEvent = _loc1_ ? _loc1_.getEventWithId(EventActivationStateCommand.EVENTTYPE_PERMAFROST_FISSURE_ASSEMBLY_WINDOW) as PermaFrostFissurEvent : null;
         if(_loc2_)
         {
            this.handlePermaFrostEventActivation(_loc2_);
         }
         super.onRegister();
      }
      
      public function switchToView(param1:INotification) : void
      {
         var _loc2_:String = param1.getBody() as String;
         if(_loc2_ == NO_ITEMS_IN_FILTER_VIEW)
         {
            this._comps.detailsContainer.visible = this._comps.buildContainer.visible = this._comps.itemListContainer.visible = false;
            this._comps.firstDivider.visible = this._comps.secondDivider.visible = false;
            this._comps.assemblyWarningContainer.visible = true;
            this._comps.assemblyWarningLabel.text = BPLocale.getItem("assembly_no_items_for_filter");
         }
         else if(_loc2_ == NO_ITEMS_IN_MODEL_VIEW)
         {
            this._comps.detailsContainer.visible = this._comps.buildContainer.visible = this._comps.itemListContainer.visible = false;
            this._comps.firstDivider.visible = this._comps.secondDivider.visible = false;
            this._comps.assemblyWarningContainer.visible = true;
            this._comps.assemblyWarningLabel.text = BPLocale.getItem("assembly_build_unavailable");
         }
         else
         {
            this._comps.detailsContainer.visible = this._comps.buildContainer.visible = this._comps.itemListContainer.visible = true;
            this._comps.firstDivider.visible = this._comps.secondDivider.visible = true;
            this._comps.assemblyWarningContainer.visible = false;
         }
      }
      
      private function handleExplanationWindowCloseNotification(param1:INotification) : void
      {
         if(this._progressCheckbox.isSelected())
         {
            this._progressCheckbox.unselect();
         }
      }
      
      private function handleEventActivationNotification(param1:INotification) : void
      {
         var _loc2_:PermaFrostFissurEvent = param1.getBody() as PermaFrostFissurEvent;
         if(_loc2_)
         {
            this.handlePermaFrostEventActivation(_loc2_);
         }
      }
      
      private function handlePermaFrostEventActivation(param1:PermaFrostFissurEvent) : void
      {
         if(param1.isActive)
         {
            this._progressCheckbox.visible = true;
            if(this._showedExplanationWindowOnce)
            {
               this._progressCheckbox.select();
               this._showedExplanationWindowOnce = !this._showedExplanationWindowOnce;
            }
         }
         else
         {
            this._progressCheckbox.visible = false;
            this._progressCheckbox.unselect();
         }
      }
      
      private function warning(param1:INotification) : void
      {
         if(!this._window.maximized)
         {
            sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,new HighlightItemVO(this._window.id,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_FLASH_WINDOW));
         }
      }
      
      private function saveFilter() : void
      {
         facade.sendNotification(AssemblyNotifications.SAVE_ASSEMBLY_FILTER_SETTINGS);
         facade.sendNotification(AssemblyNotifications.FILTER_CHANGED);
      }
      
      private function requestCollect(param1:String) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblyCollectRequest(0,param1));
      }
      
      private function requestBuild(param1:String, param2:Number) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblyBuildRequest(param1,param2));
      }
      
      private function updateRecipes(param1:INotification) : void
      {
         var _loc2_:Vector.<AssemblyRecipeModel> = param1.getBody() as Vector.<AssemblyRecipeModel>;
         this.recipes = _loc2_.concat().filter(this.filterRecipes);
      }
      
      private function filterRecipes(param1:AssemblyRecipeModel, param2:int, param3:Vector.<AssemblyRecipeModel>) : Boolean
      {
         return StringUtils.startsWith(param1.lootId,"recipe_");
      }
      
      private function updateBlinking(param1:Vector.<AssemblyRecipeModel>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:AssemblyRecipeAvailableStatusModule = null;
         if(!this._window.maximized)
         {
            _loc2_ = int(param1.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = param1[_loc3_].state.status as AssemblyRecipeAvailableStatusModule;
               if(Boolean(_loc4_) && _loc4_.isNew)
               {
                  sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,new HighlightItemVO(this._window.id,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_FLASH_WINDOW));
                  return;
               }
               _loc3_++;
            }
         }
      }
      
      private function setSelection() : void
      {
         var _loc1_:int = int(this._vectorCollection.collection.indexOf(this._currentRecipe));
         if(_loc1_ != -1)
         {
            this._currentIndex = _loc1_;
         }
         else
         {
            this._currentIndex = 0;
         }
         this._comps.recipesList.selectedIndex = this._currentIndex;
      }
      
      private function setCurrentlySelectedData() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(Boolean(this._currentRecipe) && this._window.maximized)
         {
            this._interactionView.currentRecipe = this._currentRecipe;
            this._comps.ingredients.list = new VectorCollection(this._currentRecipe.ingredients);
            _loc1_ = BPLocaleUtils.hasTranslation(TextUtils.getItemTextKey(this._currentRecipe.lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_DESCRIPTION),"items");
            _loc2_ = _loc1_ ? this._currentRecipe.lootId : this._currentRecipe.outPutItem.lootID;
            _loc3_ = TextUtils.getTranslationByType(_loc2_,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_DESCRIPTION);
            this._comps.detailsText.text = _loc3_;
            this._comps.detailsText.forceRedraw();
            _loc4_ = this._currentRecipe.outPutItem.fullname;
            if(this._currentRecipe.outPutItem.amount > 1)
            {
               this._comps.detailsHeadline.text = this._currentRecipe.outPutItem.amount + "x " + _loc4_;
            }
            else
            {
               this._comps.detailsHeadline.text = _loc4_;
            }
            this._comps.detailsTextScrollBar.setScrollPositionInPercent(0);
            this._comps.detailsTextScrollContainer.invalidate(InvalidationType.SIZE);
            _loc5_ = ItemsDataUtility.getVideoURLbyItem(this._currentRecipe.outPutItem.item);
            this.showType();
            if(_loc5_)
            {
               this._comps.detailsVid.playURL(_loc5_);
            }
            else
            {
               this._comps.detailsVid.clear();
            }
         }
      }
      
      private function hideType() : void
      {
         var _loc1_:AssemblyTemporaryType = null;
         if(this._currentRecipe)
         {
            _loc1_ = this._currentRecipe.type as AssemblyTemporaryType;
            if(_loc1_)
            {
               _loc1_.time.changed.remove(this.updateTime);
            }
         }
      }
      
      private function showType() : void
      {
         var _loc1_:AssemblyTemporaryType = this._currentRecipe ? this._currentRecipe.type as AssemblyTemporaryType : null;
         if(_loc1_)
         {
            _loc1_.time.changed.add(this.updateTime);
            this.updateTime();
            this._comps.detailsIcon.visible = this._comps.detailsTime.visible = true;
         }
         else
         {
            this._comps.detailsIcon.visible = this._comps.detailsTime.visible = false;
         }
      }
      
      private function updateTime() : void
      {
         var _loc1_:AssemblyTemporaryType = this._currentRecipe ? this._currentRecipe.type as AssemblyTemporaryType : null;
         if(_loc1_)
         {
            this._comps.detailsTime.text = HtmlTextUtils.getFormatedTimeWithColores(6676735,16777215,_loc1_.time.value,true,true,true);
         }
      }
      
      protected function handleFilterSettingsChangedEvent(param1:Event) : void
      {
         clearTimeout(this._filterUpdatePointer);
         this._filterUpdatePointer = setTimeout(this.saveFilter,100);
      }
      
      private function handleProgressCheckBoxClicked(param1:Event) : void
      {
         if(this._progressCheckbox.isSelected())
         {
            sendNotification(AssemblyNotifications.OPEN_EXPLANATION_WINDOW,AssemblyConsts.XML_RES_KEY__PERMAFROST_UI);
         }
         else
         {
            sendNotification(AssemblyNotifications.CLOSE_EXPLANATION_WINDOW);
         }
      }
      
      private function onMinimized(param1:SimpleWindowEvent) : void
      {
         this._comps.detailsVid.stop();
         if(facade.hasMediator(AssemblyExplanationWindowMediator.NAME))
         {
            facade.sendNotification(AssemblyNotifications.CLOSE_EXPLANATION_WINDOW);
            if(this._progressCheckbox.isSelected())
            {
               this._progressCheckbox.unselect();
            }
         }
      }
      
      private function onMaximized(param1:SimpleWindowEvent) : void
      {
         this.setCurrentlySelectedData();
         sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,new HighlightItemVO(this._window.id,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_FLASH_WINDOW));
      }
      
      private function handleFirstSelection(param1:MouseEvent) : void
      {
         var _loc2_:IDataReceptible = param1.target as IDataReceptible;
         if(Boolean(_loc2_) && _loc2_.data is AssemblyRecipeModel)
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblyRecipeSelectRequest((_loc2_.data as AssemblyRecipeModel).lootId));
         }
      }
      
      private function handleRightClicked(param1:MouseEvent) : void
      {
         var _loc2_:Number = this._comps.recipesList.getScrollOneItemAmount() * 13;
         this._comps.recipesList.setScrollPositionInPercent(this._comps.recipesList.getScrollPositionInPercent() + _loc2_);
      }
      
      private function handleLeftClicked(param1:MouseEvent) : void
      {
         var _loc2_:Number = this._comps.recipesList.getScrollOneItemAmount() * 13;
         this._comps.recipesList.setScrollPositionInPercent(this._comps.recipesList.getScrollPositionInPercent() - _loc2_);
      }
      
      private function handleSelectionChanged(param1:ItemListEvent) : void
      {
         this.hideType();
         this._currentIndex = param1.item.index;
         this._currentRecipe = param1.itemVO as AssemblyRecipeModel;
         this.setCurrentlySelectedData();
      }
      
      private function tabSelectionChangedHandler(param1:Event) : void
      {
         this._filterView.close();
      }
   }
}

