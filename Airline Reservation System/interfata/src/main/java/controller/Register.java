package controller;
import database.DataBase;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class Register extends JPanel {
    private final RegisterFrame frame;
    private JLabel email;
    private JLabel password;
    private JTextField emailField;
    private JPasswordField passwordField;
    private JButton login;

    public Register(RegisterFrame frame) {
        this.frame = frame;
        init();
        this.setBackground( new Color( 51, 204, 255) );
    }

    public void init(){

        Container gridLayout = new Container();
        gridLayout.setLayout( new GridLayout( 5, 1,5,5 ) );

        email = new JLabel("Email");
        email.setBounds(213, 126, 66, 62);
        gridLayout.add(email);

        emailField = new JTextField();
        emailField.setBounds(310, 140, 287, 54);
        gridLayout.add(emailField);
        emailField.setColumns(15);

        password = new JLabel("Password");
        password.setBounds(213, 223, 58, 54);
        gridLayout.add(password);

        passwordField = new JPasswordField();
        passwordField.setBounds(210, 240, 287, 54);
        gridLayout.add(passwordField);
        passwordField.setColumns(15);

        login = new JButton( "Register" );
        gridLayout.add(login);
        add( gridLayout );

        login.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent event1) {
                try {
                    Connection conn = DataBase.createConnection();

                    CallableStatement statement = conn.prepareCall( "{call register(?,?)}" );
                    // statement.registerOutParameter( 1, Types.INTEGER );
                    statement.setString( 1, emailField.getText() );
                    statement.setString( 2, passwordField.getText() );
                    statement.execute();
                    frame.setVisible( false );
                    new SearchFrame().setVisible(true);
                }catch (SQLException e) {
                    if(e.getErrorCode() == 20001){
                        JOptionPane.showMessageDialog( frame, "The user exist in the database.", "Please Enter Again", JOptionPane.WARNING_MESSAGE );
                        return;
                    }
                }
            }
        });

    }
}
