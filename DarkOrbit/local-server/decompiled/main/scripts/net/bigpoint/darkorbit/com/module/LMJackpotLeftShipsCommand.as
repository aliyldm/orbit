package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMJackpotLeftShipsCommand implements IModule
   {
      
      private static var _instance:LMJackpotLeftShipsCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var leftShips:int = 0;
      
      public function LMJackpotLeftShipsCommand(param1:LogMessengerPriorityModule = null, param2:int = 0)
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
         this.leftShips = param2;
      }
      
      public static function get instance() : LMJackpotLeftShipsCommand
      {
         return _instance || (_instance = new LMJackpotLeftShipsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 199;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         this.leftShips = param1.readInt();
         this.leftShips = this.leftShips << 5 % 32 | this.leftShips >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(199);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.leftShips >>> 5 % 32 | this.leftShips << 32 - 5 % 32);
      }
   }
}

