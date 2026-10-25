package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows
{
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   
   public class HadesStoryWindowView extends AbstractStoryWindowView
   {
      
      public function HadesStoryWindowView(param1:GalaxyGateBuilderModel, param2:Object = null)
      {
         super(ApplicationEvent.STATE_HADES,"teaser_13","title_hadesgate_info","msg_hadesgate_info",param1,param2,param1.hadesAssets);
      }
   }
}

