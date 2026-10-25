package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PageRefreshCommand implements IModule
   {
      
      private static var _instance:PageRefreshCommand;
      
      public static const PAGETYPE_TECH_FACTORY:int = 0;
      
      public static const PAGETYPE__MAX:int = 1;
      
      public var pageType:int = 0;
      
      public var openPage:Boolean = false;
      
      public function PageRefreshCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.pageType = param1;
         this.openPage = param2;
      }
      
      public static function get instance() : PageRefreshCommand
      {
         return _instance || (_instance = new PageRefreshCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -25000;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.pageType = param1.readShort();
         this.openPage = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-25000);
         param1.writeShort(this.pageType);
         param1.writeBoolean(this.openPage);
      }
   }
}

