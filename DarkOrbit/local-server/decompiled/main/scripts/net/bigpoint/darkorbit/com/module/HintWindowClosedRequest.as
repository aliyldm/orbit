package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HintWindowClosedRequest implements IModule
   {
      
      private static var _instance:HintWindowClosedRequest;
      
      public var closedWindow:HintWindowModule;
      
      public var wasOpenedFromArchive:Boolean = false;
      
      public function HintWindowClosedRequest(param1:HintWindowModule = null, param2:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.closedWindow = new HintWindowModule();
         }
         else
         {
            this.closedWindow = param1;
         }
         this.wasOpenedFromArchive = param2;
      }
      
      public static function get instance() : HintWindowClosedRequest
      {
         return _instance || (_instance = new HintWindowClosedRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15966;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.closedWindow = HintWindowModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.closedWindow)
         {
            this.closedWindow.read(param1);
         }
         this.wasOpenedFromArchive = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-15966);
         if(null != this.closedWindow)
         {
            this.closedWindow.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.wasOpenedFromArchive);
      }
   }
}

