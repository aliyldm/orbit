package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMItemCollectedCommand implements IModule
   {
      
      private static var _instance:LMItemCollectedCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var lootId:String = "";
      
      public function LMItemCollectedCommand(param1:LogMessengerPriorityModule = null, param2:String = "")
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
         this.lootId = param2;
      }
      
      public static function get instance() : LMItemCollectedCommand
      {
         return _instance || (_instance = new LMItemCollectedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 213;
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
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(213);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.lootId);
      }
   }
}

