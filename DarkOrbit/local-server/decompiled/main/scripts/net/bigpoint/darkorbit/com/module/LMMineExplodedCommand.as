package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMMineExplodedCommand implements IModule
   {
      
      private static var _instance:LMMineExplodedCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var hash:String = "";
      
      public function LMMineExplodedCommand(param1:LogMessengerPriorityModule = null, param2:String = "")
      {
         super();
         if(param1 == null)
         {
            this.priorityMode = new LogMessengerPriorityModule();
         }
         else
         {
            this.priorityMode = param1;
         }
         this.hash = param2;
      }
      
      public static function get instance() : LMMineExplodedCommand
      {
         return _instance || (_instance = new LMMineExplodedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 215;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         this.hash = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(215);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.hash);
      }
   }
}

