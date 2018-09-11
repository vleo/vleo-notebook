public class MessagesDAO
{
  private static MessagesDAO instance;
  private final Long context;

  private MessagesDAO(Long context){
    this.context = context;
  }



  public static MessagesDAO getInstance(Long paramContext)
  {

    synchronized(MessagesDAO.class){

			try {
				if (instance == null) {
					MessagesDAO instanceTmp1 = new MessagesDAO(paramContext);
					instance = instanceTmp1;
					}
			} finally {}

			return instance;
		}
  }
}
