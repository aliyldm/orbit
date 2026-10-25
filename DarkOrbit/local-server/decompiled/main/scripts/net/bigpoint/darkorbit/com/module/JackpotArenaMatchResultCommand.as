package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JackpotArenaMatchResultCommand implements IModule
   {
      
      private static var _instance:JackpotArenaMatchResultCommand;
      
      public var hint:MessageLocalizedCommand;
      
      public var loserData:JackpotArenaMatchResultModule;
      
      public var winnerData:JackpotArenaMatchResultModule;
      
      public var isWinner:Boolean = false;
      
      public function JackpotArenaMatchResultCommand(param1:Boolean = false, param2:JackpotArenaMatchResultModule = null, param3:JackpotArenaMatchResultModule = null, param4:MessageLocalizedCommand = null)
      {
         super();
         if(param4 == null)
         {
            this.hint = new MessageLocalizedCommand();
         }
         else
         {
            this.hint = param4;
         }
         if(param3 == null)
         {
            this.loserData = new JackpotArenaMatchResultModule();
         }
         else
         {
            this.loserData = param3;
         }
         if(param2 == null)
         {
            this.winnerData = new JackpotArenaMatchResultModule();
         }
         else
         {
            this.winnerData = param2;
         }
         this.isWinner = param1;
      }
      
      public static function get instance() : JackpotArenaMatchResultCommand
      {
         return _instance || (_instance = new JackpotArenaMatchResultCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9705;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.hint = MessageLocalizedCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.hint)
         {
            this.hint.read(param1);
         }
         this.loserData = JackpotArenaMatchResultModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.loserData)
         {
            this.loserData.read(param1);
         }
         this.winnerData = JackpotArenaMatchResultModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.winnerData)
         {
            this.winnerData.read(param1);
         }
         this.isWinner = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9705);
         if(null != this.hint)
         {
            this.hint.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.loserData)
         {
            this.loserData.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.winnerData)
         {
            this.winnerData.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.isWinner);
      }
   }
}

