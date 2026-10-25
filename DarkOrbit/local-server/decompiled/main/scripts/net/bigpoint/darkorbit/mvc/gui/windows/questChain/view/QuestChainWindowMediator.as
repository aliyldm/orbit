package net.bigpoint.darkorbit.mvc.gui.windows.questChain.view
{
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.questChain.model.QuestChainWindowProxy;
   
   public class QuestChainWindowMediator extends SimpleWindowMediator
   {
      
      public function QuestChainWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override protected function mapNotificationsToMethods() : void
      {
      }
      
      override public function loadAndBuildContent(param1:String) : void
      {
         super.loadAndBuildContent(param1);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         this.assignUIComponents();
         this.addEventListeners();
         super.handleLoadAndBuildContentCallback(param1);
         this.onContentedLoadUpdateViewComponentFromModel();
      }
      
      private function addEventListeners() : void
      {
      }
      
      private function removeEventListeners() : void
      {
      }
      
      private function assignUIComponents() : void
      {
      }
      
      private function onContentedLoadUpdateViewComponentFromModel() : void
      {
         var _loc1_:QuestChainWindowProxy = facade.retrieveProxy(GuiConstants.QUEST_CHAIN_WINDOW) as QuestChainWindowProxy;
      }
   }
}

