package net.bigpoint.darkorbit.mvc.crafting.assembly.view
{
   import flash.events.Event;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.video.VideoPlayer;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   
   public class AssemblyExplanationWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "AssemblyExplanationWindowMediator";
      
      private var window:SimpleWindow;
      
      private var root:Container;
      
      private var textContainer:Container;
      
      private var headerline:Label;
      
      private var infoLabel:Label;
      
      private var infoScrollContainer:Container;
      
      private var infoScrollbar:Scrollbar;
      
      private var itemVideoPlayer:VideoPlayer;
      
      private var itemScrollbar:Scrollbar;
      
      private var itemLabel:Label;
      
      private var itemScrollContainer:ScrollContainer;
      
      public function AssemblyExplanationWindowMediator(param1:SimpleWindow, param2:Container)
      {
         super(NAME);
         this.window = param1;
         this.root = FuiComponentSelectorUtil.selectComponent("root",param2) as Container;
         this.headerline = FuiComponentSelectorUtil.selectComponent("root.headline",param2) as Label;
         this.textContainer = FuiComponentSelectorUtil.selectComponent("root.textContainer",param2) as Container;
         this.infoLabel = FuiComponentSelectorUtil.selectComponent("root.textContainer.assemblyExpScrollContainerText.content",param2) as Label;
         this.infoScrollContainer = FuiComponentSelectorUtil.selectComponent("root.textContainer.assemblyExpScrollContainerText",param2) as ScrollContainer;
         this.infoScrollbar = FuiComponentSelectorUtil.selectComponent("root.textContainer.assemblyExpScrollbarText",param2) as Scrollbar;
         this.itemVideoPlayer = FuiComponentSelectorUtil.selectComponent("root.itemcontainer.videoplayer",param2) as VideoPlayer;
         this.addEventListeners();
      }
      
      private function update() : void
      {
         var _loc1_:String = ItemsDataUtility.getVideoURLbyLootId("ammunition_laser_rsb-75");
         this.window.setTitle("window_assembly_explanation_windowtitle");
         this.headerline.text = BPLocale.getItem("window_assembly_explanation_header");
         this.infoLabel.text = BPLocale.getItem("window_assembly_explanation_description");
         this.infoLabel.forceRedraw();
         this.textContainer.forceRedraw();
         this.infoScrollbar.setScrollPositionInPercent(0);
         this.infoScrollContainer.invalidate(InvalidationType.SIZE);
         if(this.itemLabel)
         {
            this.itemLabel.text = BPLocale.getItem("window_assembly_explanation_iteminfo");
            this.itemLabel.forceRedraw();
         }
         if(Boolean(this.itemScrollbar) && Boolean(this.itemScrollContainer))
         {
            this.itemScrollbar.setScrollPositionInPercent(0);
            this.itemScrollContainer.invalidate(InvalidationType.SIZE);
         }
         this.itemVideoPlayer.playURL(_loc1_);
      }
      
      private function addEventListeners() : void
      {
         this.window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleWindowMaximized);
         this.window.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleWindowMinimized);
      }
      
      private function removeEventListeners() : void
      {
         this.window.removeEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleWindowMaximized);
         this.window.removeEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleWindowMinimized);
      }
      
      private function handleWindowMinimized(param1:Event) : void
      {
         facade.sendNotification(AssemblyConsts.EVENT_EXPLANATION_WINDOW_CLOSED);
         this.itemVideoPlayer.stop();
      }
      
      private function handleWindowMaximized(param1:Event) : void
      {
         this.update();
      }
   }
}

