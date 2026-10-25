package net.bigpoint.darkorbit.mvc.companyhierarchy.model.proxy
{
   import mx.collections.ArrayList;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.CompanyHierarchyNotifications;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class CompanyHierarchyProxy extends Proxy implements IProxy
   {
      
      public static const NAME:String = "CompanyHierarchyProxy";
      
      private var rankedClans:Vector.<ArrayList>;
      
      public function CompanyHierarchyProxy()
      {
         super(NAME);
         this.rankedClans = new Vector.<ArrayList>();
      }
      
      public function handleFactionTabSwitchedRequest(param1:int) : void
      {
         sendNotification(CompanyHierarchyNotifications.RANKED_CLANS_UPDATE,this.rankedClans[param1]);
      }
      
      public function handleRankedClansUpdateFromServer(param1:Vector.<ArrayList>, param2:int) : void
      {
         if(param2 == 0)
         {
            param2 = Hero.factionID.value;
         }
         this.rankedClans = param1;
         facade.sendNotification(CompanyHierarchyNotifications.SELECTED_COMPANY_CHANGED,param2);
      }
   }
}

