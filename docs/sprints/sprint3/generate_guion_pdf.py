from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, ListFlowable, ListItem
from reportlab.lib import colors

output_path = r"c:\xampp\tomcat\webapps\inmobiliaria-java-web\docs\sprints\sprint3\guion-sustentacion.pdf"

styles = getSampleStyleSheet()
styles.add(ParagraphStyle(name='TitleCentered', parent=styles['Title'], alignment=1, fontSize=22, leading=26, textColor=colors.HexColor('#0F3A5B')))
styles.add(ParagraphStyle(name='Heading2', parent=styles['Heading2'], fontSize=14, textColor=colors.HexColor('#0F3A5B'), leading=18, spaceBefore=10, spaceAfter=8))
styles.add(ParagraphStyle(name='Body', parent=styles['BodyText'], fontSize=10, leading=14, spaceAfter=8, textColor=colors.HexColor('#1F1F1F')))
styles.add(ParagraphStyle(name='Small', parent=styles['BodyText'], fontSize=9, leading=12, textColor=colors.HexColor('#444444')))

content = []
content.append(Paragraph('Dream House S.A.', style='TitleCentered'))
content.append(Paragraph('Guion de sustentación - Sprint 3', style='Heading2'))
content.append(Paragraph('Proyecto: Aplicación web para gestión inmobiliaria', style='Small'))
content.append(Spacer(1, 14))

sections = [
    ('1. Objetivo del proyecto', 'Desarrollar una aplicación web para administrar propiedades, citas, solicitudes, documentos, reportes y seguridad por roles en un entorno real con Java, JSP, JDBC y MariaDB.'),
    ('2. Alcance entregado', 'Se validaron propiedades, citas, solicitudes, auditoría, reportes, control de acceso, carga real de documentos y documentación técnica del modelo de datos.'),
    ('3. Seguridad y acceso', 'Se protege el acceso con filtro de servlet y validación por sesión y rol. Las contraseñas se manejan con hash seguro. Los datos se validan en servidor antes de ejecutar cambios.'),
    ('4. Modelo de datos', 'El proyecto usa relaciones 1:1, 1:N y N:M. Se incorporaron restricciones UNIQUE como email, matrícula inmobiliaria y perfil por usuario para evitar duplicados.'),
    ('5. Consultas SQL obligatorias', 'Se documentaron cinco consultas clave: dos INNER JOIN, relación N:M, LEFT JOIN y GROUP BY con HAVING para reportes de negocio.'),
    ('6. Demostración funcional', 'La sustentación puede mostrar el landing, el login, la gestión de propiedades, la agenda de citas, la creación de solicitudes, la carga de documentos y la auditoría.'),
    ('7. Evidencias y cierre', 'Se dejó documentación de planning, review, retrospective, matriz de pruebas, modelo de datos y guion de sustentación para respaldar la entrega.'),
    ('8. Preguntas frecuentes', '¿Qué validaciones se hacen en servidor? ¿Cómo se evita la duplicación de registros? ¿Qué pasa si se intenta volver a un estado anterior?')
]

for title, text in sections:
    content.append(Paragraph(title, style='Heading2'))
    content.append(Paragraph(text, style='Body'))

content.append(Spacer(1, 10))
content.append(Paragraph('Puntos clave para resumir en la sustentación', style='Heading2'))
content.append(ListFlowable([
    ListItem(Paragraph('Se protegieron rutas privadas por rol y por propietario.', style='Body')),
    ListItem(Paragraph('Las transiciones de estado en citas y solicitudes no permiten regresiones.', style='Body')),
    ListItem(Paragraph('La matrícula inmobiliaria es única y se valida en alta y edición.', style='Body')),
    ListItem(Paragraph('Los documentos reales se almacenan en WEB-INF/uploads y se validan por pertenencia.', style='Body')),
    ListItem(Paragraph('La auditoría registra cambios reales y los reportes se calculan desde la base de datos.', style='Body')),
], bulletType='bullet', leftIndent=20, style=styles['Body']))

content.append(Spacer(1, 12))
content.append(Paragraph('Cierre sugerido', style='Heading2'))
content.append(Paragraph('La aplicación quedó entregada con validaciones funcionales, seguridad por servidor, documentación técnica y evidencia de pruebas. La sustentación debe mostrar que el alumno puede explicar el flujo, la base de datos y la lógica de control de acceso con lenguaje claro y preciso.', style='Body'))

doc = SimpleDocTemplate(output_path, pagesize=A4, rightMargin=36, leftMargin=36, topMargin=30, bottomMargin=30)
doc.build(content)
print(f'PDF generado: {output_path}')
