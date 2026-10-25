package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ClanSearchNameTagCommand implements IModule
   {
      
      private static var _instance:ClanSearchNameTagCommand;
      
      public var lookup:String = "";
      
      public var infoCommandList:Vector.<ClanNameTagInfoCommand>;
      
      public function ClanSearchNameTagCommand(param1:String = "", param2:Vector.<ClanNameTagInfoCommand> = null)
      {
         super();
         this.lookup = param1;
         if(param2 == null)
         {
            this.infoCommandList = new Vector.<ClanNameTagInfoCommand>();
         }
         else
         {
            this.infoCommandList = param2;
         }
      }
      
      public static function get instance() : ClanSearchNameTagCommand
      {
         return _instance || (_instance = new ClanSearchNameTagCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31128;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanNameTagInfoCommand = null;
         this.lookup = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.infoCommandList.length > 0)
         {
            this.infoCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanNameTagInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.infoCommandList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanNameTagInfoCommand = null;
         param1.writeShort(-31128);
         param1.writeUTF(this.lookup);
         param1.writeByte(this.infoCommandList.length);
         for each(_loc2_ in this.infoCommandList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

