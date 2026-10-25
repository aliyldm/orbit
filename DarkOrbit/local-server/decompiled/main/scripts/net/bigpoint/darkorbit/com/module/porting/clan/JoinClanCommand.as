package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class JoinClanCommand implements IModule
   {
      
      private static var _instance:JoinClanCommand;
      
      public var clanAllInfoCommand:ClanAllInfoCommand;
      
      public function JoinClanCommand(param1:ClanAllInfoCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.clanAllInfoCommand = new ClanAllInfoCommand();
         }
         else
         {
            this.clanAllInfoCommand = param1;
         }
      }
      
      public static function get instance() : JoinClanCommand
      {
         return _instance || (_instance = new JoinClanCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10813;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanAllInfoCommand = ClanAllInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanAllInfoCommand)
         {
            this.clanAllInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10813);
         if(null != this.clanAllInfoCommand)
         {
            this.clanAllInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

