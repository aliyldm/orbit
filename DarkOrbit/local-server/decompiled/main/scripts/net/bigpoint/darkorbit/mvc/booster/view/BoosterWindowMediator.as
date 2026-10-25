package net.bigpoint.darkorbit.mvc.booster.view
{
   import com.bigpoint.utils.PointLite;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBoxEvent;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.booster.BoosterConsts;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterCategory;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterModel;
   import net.bigpoint.darkorbit.mvc.booster.view.details.BoosterDetailsView;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowDefinitionVO;
   
   public class BoosterWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "BoosterWindowMediator";
      
      private var _data:BoosterModel;
      
      private var _boosterList:BoosterListView;
      
      private var _boosterDetail:BoosterDetailsView;
      
      private var _window:SimpleWindow;
      
      private var _definition:FeatureWindowDefinitionVO;
      
      private var _tmpWindowPosition:PointLite;
      
      public function BoosterWindowMediator(param1:Object = null, param2:SimpleWindow = null)
      {
         super(NAME,param1);
         this._window = param2;
         this._window.addEventListener(SimpleWindowEvent.RESIZE_STOP,this.handleWindowSizeChanged);
         this._window.addEventListener(SimpleWindowEvent.START_DRAG,this.handleWindowDrag);
         this._window.setWidth(200);
         this._boosterList = new BoosterListView(param1 as Container);
         this._boosterDetail = new BoosterDetailsView(param1 as Coreponent);
         this._boosterList.list.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleDetailsExpanded);
         this._boosterList.filter.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleFilterChanged);
         this._boosterDetail.filterActive = this._boosterList.filter.isSelected();
      }
      
      private function handleFilterChanged(param1:CheckBoxEvent) : void
      {
         this._boosterDetail.filterActive = param1.selected;
         this.update();
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this._definition = guiProxy.getFeatureWindowById(GuiConstants.BOOSTER_WINDOW).definition;
         this.handleWindowSizeChanged();
      }
      
      private function handleWindowSizeChanged(param1:SimpleWindowEvent = null) : void
      {
         setTimeout(this.updateHeight,1);
      }
      
      private function updateHeight() : void
      {
         this._boosterList.updateHeight(this._window.height - BoosterConsts.MAGIC_OFFSET);
      }
      
      private function handleWindowDrag(param1:SimpleWindowEvent) : void
      {
         this._tmpWindowPosition = null;
      }
      
      private function handleDetailsExpanded(param1:ItemListEvent) : void
      {
         if(Boolean(param1.item) && Boolean(param1.item.isSelected()))
         {
            this._tmpWindowPosition = this._tmpWindowPosition || this._window.position;
            this._definition.resizeBounds = BoosterConsts.BIG_BOUNDS;
            this._boosterDetail.data = param1.itemVO as BoosterCategory;
            this._window.setWidth(BoosterConsts.BIG_BOUNDS.x);
            this._window.checkAndSavePosition();
         }
         else
         {
            this._definition.resizeBounds = BoosterConsts.SMALL_BOUNDS;
            this._boosterDetail.data = null;
            this._window.setWidth(BoosterConsts.SMALL_BOUNDS.x);
            if(this._tmpWindowPosition)
            {
               this._window.position = this._tmpWindowPosition;
               this._tmpWindowPosition = null;
            }
         }
         this._window.assignValuesFromFeatureWindowVO(guiProxy.getFeatureWindowById(GuiConstants.BOOSTER_WINDOW));
      }
      
      public function set data(param1:BoosterModel) : void
      {
         this.removeListeners();
         this._data = param1;
         this.addListeners();
         this.update();
      }
      
      private function addListeners() : void
      {
         if(this._data)
         {
            this._data.changed.add(this.update);
         }
      }
      
      private function removeListeners() : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
         }
      }
      
      private function update() : void
      {
         var _loc1_:VectorCollection = new VectorCollection(this._data.getCategories(this._boosterList.filter.isSelected()));
         this._boosterList.list.list = _loc1_;
         this._boosterList.updateScrollButtons();
      }
   }
}

