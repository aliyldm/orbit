package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model
{
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.vo.RankingsUIEventsVO;
   
   public class RankingsUIEventsProxy extends SimpleWindowProxy
   {
      
      public function RankingsUIEventsProxy(param1:String)
      {
         super(param1,new RankingsUIEventsData());
      }
      
      public function get viewData() : RankingsUIEventsData
      {
         return data as RankingsUIEventsData;
      }
      
      public function updateEventsInfo(param1:Boolean, param2:RankingsUIEventsVO) : *
      {
         this.viewData.updateEventsInfo(param1,param2);
      }
   }
}

